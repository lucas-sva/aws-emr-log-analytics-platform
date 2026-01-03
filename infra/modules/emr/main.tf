resource "aws_emr_cluster" "this" {
  name          = "${var.project_name}-${var.environment}-emr-cluster"
  release_label = var.release_label
  service_role  = aws_iam_role.service_role.arn
  applications  = var.applications

  # Url para os logs no S3
  log_uri = "s3://${var.s3_bucket_log_id}/emr-logs/"

  # Configurações de networking e security
  ec2_attributes {
    subnet_ids                        = var.subnet_ids
    emr_managed_master_security_group = aws_security_group.master.id
    emr_managed_slave_security_group  = aws_security_group.slave.id
    service_access_security_group     = aws_security_group.service_access.id
    instance_profile                  = aws_iam_instance_profile.emr_profile.arn
  }

  # Fleet 1: Master Node on-demand
  master_instance_fleet {
    name                      = "MasterFleet"
    target_on_demand_capacity = 1

    instance_type_configs {
      instance_type = var.master_instance_type
    }
  }

  # Fleet 2: Core Nodes para o HDFS on-demand
  core_instance_fleet {
    name                      = "CoreFleet"
    target_on_demand_capacity = var.core_instance_count

    instance_type_configs {
      instance_type = var.core_instance_type
      ebs_config {
        size                 = 32
        type                 = "gp3"
        volumes_per_instance = 1
      }
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-emr"
    Environment = var.environment
  }
}

resource "aws_emr_instance_fleet" "task_fleet" {
  name                      = "TaskSpotFleet"
  cluster_id                = aws_emr_cluster.this.id
  target_spot_capacity      = var.task_spot_target_capacity
  target_on_demand_capacity = 0

  # O fleet escolhe a instância mais barata da lista de opções
  dynamic "instance_type_configs" {
    for_each = var.task_instance_types
    content {
      instance_type = instance_type_configs.value
    }
  }

  # Configuração de timeout para o Spot
  launch_specifications {
    spot_specification {
      allocation_strategy      = "capacity-optimized"
      timeout_action           = "SWITCH_TO_ON_DEMAND"
      timeout_duration_minutes = 10
    }
  }
}