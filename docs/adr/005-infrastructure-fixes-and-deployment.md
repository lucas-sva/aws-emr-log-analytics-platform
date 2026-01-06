# 5. Estratégia de Deploy de Artefatos e Correções de Segurança

* **Status**: Aceito
* **Data**: 2026-01-06
* **Responsável:** Lucas Galdino
* **Drivers da Decisão:**
    * Necessidade de automação idempotente para deploy de código da aplicação.
    * Restrições de conectividade (NAT/Internet) em Subnets Privadas durante o bootstrap.
    * Bloqueios (Deadlocks) recorrentes na destruição de recursos de rede interdependentes.

## Contexto
Durante a implementação da pipeline de ETL Batch no EMR em subnets privadas, encontramos desafios técnicos relacionados ao ciclo de vida dos recursos (Terraform Destroy), dependências de rede para instalação de pacotes Python e sincronização de código.

## Decisões

### 1. Upload de Artefatos via Terraform
Optamos por utilizar o recurso `aws_s3_object` do Terraform para gerenciar o upload de scripts (`.py`, `.sh`) e dados de teste.
* **Motivo:** Garante que a infraestrutura e a versão do código da aplicação estejam sempre sincronizados. O uso de `etag = filemd5(...)` garante idempotência.

### 2. Execução "Batteries Included" (Sem Pip)
Para esta fase, removemos a dependência de instalação de pacotes externos (`pip install`) no Bootstrap.
* **Motivo:** Evitar complexidade de configuração de NAT Gateway/DNS e falhas de rede intermitentes na inicialização do cluster. Utilizamos funções nativas do Spark (`pyspark.sql.functions`) que rodam na JVM e não requerem bibliotecas Python extras.

### 3. Resolução de Deadlock em Security Groups
Habilitamos `revoke_rules_on_delete = true` nos Security Groups do EMR.
* **Motivo:** O Terraform falhava ao destruir a infraestrutura devido a referências cíclicas (Master <-> Slave <-> Service). Essa configuração força a remoção das regras antes da exclusão do grupo.

## Consequências
* O processo de *Destroy* agora é 100% automatizado e livre de erros.
* O cluster tem um tempo de inicialização mais estável sem dependências externas de internet.

## Links de Referência
* [Terraform: Resource aws_s3_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)
* [Terraform: Resource aws_security_group (revoke_rules_on_delete)](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#revoke_rules_on_delete)
* [PySpark: pyspark.sql.functions](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/functions.html)