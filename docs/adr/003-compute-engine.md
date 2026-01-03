# ADR-003: Motor de Processamento Distribuído (Amazon EMR)

* **Status:** Aceito
* **Data:** 2026-01-02
* **Responsável:** Lucas Galdino
* **Drivers da Decisão:** Eficiência de Custo (FinOps), Performance, Compatibilidade Big Data, Coesão de Módulo.

## Contexto
A plataforma requer um motor de processamento capaz de executar frameworks distribuídos (Apache Spark e Apache Flink) para tratar grandes volumes de logs.

Avaliamos opções como **EMR Serverless** e **EMR on EKS**. Embora ofereçam menor overhead operacional, o custo por vCPU/hora é significativamente maior do que instâncias EC2 Spot. Como este é um projeto de laboratório/acadêmico, a prioridade é maximizar o poder de processamento com o menor orçamento possível, mantendo a oportunidade de aprendizado sobre gerenciamento de clusters.

## Decisão
Utilizaremos o **Amazon EMR (Elastic MapReduce) on EC2**, configurado com **Instance Fleets** e alta utilização de **Spot Instances**.

Além disso, adotaremos uma estratégia de **Encapsulamento de Módulo**, onde os recursos de segurança (Security Groups) e permissões (IAM Roles) específicos do cluster serão definidos internamente no módulo do EMR, garantindo alta coesão.

### 1. Estratégia de Computação (Compute & Spot)
* **Gerenciamento:** Utilização de **Instance Fleets**.
* **Master Node:** 1 instância On-Demand (garantia de estabilidade do control plane).
* **Core Nodes:** 1 instância On-Demand (garantia de estabilidade do HDFS).
* **Task Nodes:** Instâncias **Spot** provisionadas via Fleet.
    * *Mecanismo:* O Fleet permite listar múltiplas famílias (ex: `m5.xlarge`, `r5.xlarge`, `c5.xlarge`). O EMR escolhe automaticamente a opção mais barata disponível na AZ, mitigando a indisponibilidade de um tipo específico.

### 2. Arquitetura de Módulo (Encapsulamento)
Diferente das camadas de Networking e Storage (que são globais), os recursos de segurança do EMR possuem acoplamento forte com o cluster.
* **IAM Roles:** `EMR_DefaultRole` e `EMR_EC2_DefaultRole` serão criadas dentro do módulo `modules/emr`.
* **Security Groups:** O firewall que libera portas do Spark UI (8890) e comunicação interna será criado dentro do módulo `modules/emr`.
* **Benefício:** Ao destruir o módulo (`terraform destroy`), garantimos que não restarão configurações de permissão órfãs na conta AWS.

### 3. Versão e Software
* **EMR Release:** `emr-7.1.0` (ou superior).
* **Stack:** Spark 3.5+, Flink 1.18+, Hadoop 3.3+.

## Consequências
* **Positiva (FinOps):** Redução estimada de custos entre 60-90% nos nós de tarefa (Task Nodes) comparado ao preço On-Demand ou Serverless.
* **Positiva (Operacional):** Maior controle sobre parâmetros da JVM e YARN, permitindo tuning fino de performance.
* **Negativa:** Necessidade de gerenciar interrupções de Spot (o código Spark/Flink deve ser resiliente a falhas de nós).

## Referências
* [Melhores práticas para usar instâncias Spot no Amazon EMR](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-plan-spot-instances.html)
* [Comparativo de custos: Serverless vs Spot](https://aws.amazon.com/emr/pricing/)
* [Encapsulamento e Modularização em Terraform](https://developer.hashicorp.com/terraform/language/modules/develop)