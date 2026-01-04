resource "aws_security_group" "master" {
  name        = "${var.project_name}-${var.environment}-emr-master-sg"
  description = "Security Group for EMR Master Node"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-emr-master-sg"
  }
}

resource "aws_security_group" "slave" {
  name        = "${var.project_name}-${var.environment}-emr-slave-sg"
  description = "Security Group for EMR Slave Nodes (Core/Task)"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# OBRIGATÓRIO para clusters em Subnets Privadas.
resource "aws_security_group" "service_access" {
  name        = "${var.project_name}-${var.environment}-emr-service-access-sg"
  description = "Security Group for EMR Service Access (Private Subnets)"
  vpc_id      = var.vpc_id

  # A AWS gerencia as regras de ingress automaticamente para este SG quando o Cluster é criado,
  # permitindo tráfego da porta 8443/9443 do control plane. Então só precisamos da saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-emr-service-access-sg"
  }
}

# Regras de comunicação interna entre o Master, o Service Access e os Slaves

# O master aceita tudo que venha dos Slaves
resource "aws_security_group_rule" "master_ingress_from_slave" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.slave.id
  security_group_id        = aws_security_group.master.id
}

# O Master aceita tudo que vem dele mesmo
resource "aws_security_group_rule" "master_ingress_self" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.master.id # self
  security_group_id        = aws_security_group.master.id
}

#O Master aceita o tráfego do Service Access
resource "aws_security_group_rule" "master_ingress_from_service" {
  type                     = "ingress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.service_access.id
  security_group_id        = aws_security_group.master.id
}

# Os Slaves aceitam tudo que venha do Master
resource "aws_security_group_rule" "slave_ingress_from_master" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.master.id
  security_group_id        = aws_security_group.slave.id
}

# Os Slaves aceitam tudo que vem deles mesmos
resource "aws_security_group_rule" "slave_ingress_self" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.slave.id # Self
  security_group_id        = aws_security_group.slave.id
}

# Os Slaves aceitam o tráfego do Service Access
resource "aws_security_group_rule" "slave_ingress_from_service" {
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.service_access.id
  security_group_id        = aws_security_group.slave.id
}

# O Service Access aceita sinais do Master (Porta 9443)
resource "aws_security_group_rule" "service_access_ingress_from_master" {
  type                     = "ingress"
  from_port                = 9443
  to_port                  = 9443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.master.id
  security_group_id        = aws_security_group.service_access.id
}

# O Service Access aceita sinais dos Slaves (Porta 8443)
# (Adicionando preventivamente, pois ele provavelmente reclamaria disso em seguida)
resource "aws_security_group_rule" "service_access_ingress_from_slave" {
  type                     = "ingress"
  from_port                = 8443
  to_port                  = 8443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.slave.id
  security_group_id        = aws_security_group.service_access.id
}
