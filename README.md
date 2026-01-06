# AWS EMR Log Analytics Platform

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Apache Spark](https://img.shields.io/badge/Apache%20Spark-FDEE21?style=for-the-badge&logo=apachespark&logoColor=black)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)

## 📋 Overview

Plataforma de Engenharia de Dados projetada para ingerir e analisar logs de segurança (Web Server Logs) em escala. A arquitetura utiliza **Terraform** para provisionamento de infraestrutura imutável e **Amazon EMR com Apache Spark** para processamento distribuído em lote (Batch), com foco agressivo em otimização de custos (FinOps).

### 🎯 Business Case
Em cenários de Cibersegurança, o volume de logs gerados pode atingir Terabytes rapidamente. Analisar esses dados manualmente é inviável. Este projeto automatiza o processamento massivo de logs armazenados no Data Lake (S3), permitindo a detecção de padrões maliciosos e gerando relatórios consolidados de forma escalável e auditável.

## 🏗️ Arquitetura da Solução

![Diagrama de Arquitetura EMR Log Analytics](docs/img/arquitetura-emr.png)

A plataforma implementa um **Data Lakehouse** modular na AWS, priorizando segurança e isolamento de recursos. O fluxo de dados segue o modelo de camadas (Medallion Architecture simplificada):

### 1. Camada de Armazenamento (Data Lake)
Utilizamos o **Amazon S3** segregado em buckets lógicos:
* **Raw Zone (Bronze):** Recebe os logs brutos (ex: arquivos `.txt` gerados pelo servidor de aplicação). A ingestão é preparada para arquivos imutáveis.
* **Processed Zone (Silver):** Armazena os dados limpos, tipados e convertidos para **Parquet**, particionados por status code para otimização de leitura.
* **Administrative Zone:** Armazena artefatos de infraestrutura, como scripts de Bootstrap (`init.sh`) e Jobs Spark (`.py`), além de logs de auditoria do cluster.

### 2. Camada de Processamento (Compute)
O processamento é realizado via **Amazon EMR (Elastic MapReduce)** versão 7.1.0:
* **Engine:** Apache Spark para processamento distribuído em memória.
* **Estratégia FinOps:** Uso de **Instance Fleets** combinando instâncias On-Demand (Master) para estabilidade e Spot (Tasks) para redução de custos.
* **Bootstrap Actions:** Scripts Shell que rodam na inicialização das máquinas para instalar dependências Python e configurar o ambiente.

### 3. Segurança e Networking (Zero Trust)
A infraestrutura de rede foi desenhada para não expor dados:
* **VPC Customizada:** O Cluster EMR reside inteiramente em **Subnets Privadas**, sem IPs públicos.
* **Saída Controlada:** O acesso à internet (para baixar libs Python) é feito via **NAT Gateway** na subnet pública.
* **Acesso Interno:** A comunicação com o S3 utiliza **VPC Endpoints** (Gateway), garantindo que o tráfego de dados massivos não saia da rede interna da AWS (reduzindo latência e custo).
* **Criptografia:** Dados criptografados em repouso (SSE-S3) e trânsito (TLS).

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