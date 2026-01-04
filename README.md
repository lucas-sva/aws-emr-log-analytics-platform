# AWS EMR Log Analytics Platform

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Apache Spark](https://img.shields.io/badge/Apache%20Spark-FDEE21?style=for-the-badge&logo=apachespark&logoColor=black)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

## 📋 Overview

Plataforma de Engenharia de Dados projetada para ingerir e analisar logs de segurança (Web Server Logs) em escala. A arquitetura utiliza **Terraform** para provisionamento de infraestrutura imutável e **Amazon EMR com Apache Spark** para processamento distribuído em lote (Batch), com foco agressivo em otimização de custos (FinOps).

### 🎯 Business Case
Em cenários de Cibersegurança, o volume de logs gerados pode atingir Terabytes rapidamente. Analisar esses dados manualmente é inviável. Este projeto automatiza o processamento massivo de logs armazenados no Data Lake (S3), permitindo a detecção de padrões maliciosos e gerando relatórios consolidados de forma escalável e auditável.

### 🏗️ Arquitetura

![Diagrama de Arquitetura EMR Log Analytics](docs/img/arquitetura-emr.png)

A solução segue o padrão **Lakehouse** com foco em **Zero Trust Networking**:
1.  **Ingestion:** Amazon S3 (Raw Zone) com triggers via AWS Lambda.
<br>
2.  **Compute:** Cluster EMR efêmero com instâncias Spot (FinOps).
<br>
3.  **Security:** VPC Customizada com Subnets Privadas (sem acesso direto à internet).
    * VPC Endpoints para tráfego S3 (sem NAT Gateway para dados).
    * Criptografia em repouso (KMS) e trânsito (TLS).
<br>
4. **Quality & CI:** Pipeline de Integração Contínua (GitHub Actions) validando segurança e formatação do Terraform a cada commit.

## 🚀 Quick Start

### Pré-requisitos
* Docker e Docker Compose instalados.
* Credenciais AWS configuradas em `~/.aws/credentials`.

### Como Rodar (Ambiente Isolado)

Não é necessário instalar Terraform ou AWS CLI na sua máquina. Utilizamos uma **Toolbox** containerizada para garantir reprodutibilidade.

1. **Inicie a Toolbox:**
   ```bash
   docker compose run --rm toolbox
   ```

2. **Dentro do container, faça o deploy:**
    ```bash
    cd infra/live/dev
    terraform init
    terraform apply
    ```
## 📚 Documentação

Este repositório serve como material de estudo. Para guias detalhados, acesse:

* **[Wiki do Projeto](../../wiki):** Contém o guia detalhado de configuração de ambiente, manuais de operação e detalhamento da infraestrutura.
* **[Architecture Decision Records (ADRs)](docs/adr/):** Registros históricos do porquê de cada tecnologia e padrão de segurança foram escolhidos (ex: Networking, Storage, compute-engine).