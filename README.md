# AWS EMR Log Analytics Platform

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Apache Flink](https://img.shields.io/badge/Apache%20Flink-E6526F?style=for-the-badge&logo=apacheflink&logoColor=white)

## 📋 Overview

Plataforma de Engenharia de Dados *event-driven* projetada para ingerir e analisar logs de segurança (Web Server Logs) em escala. A arquitetura utiliza **Terraform** para provisionamento de infraestrutura imutável, **Amazon EMR** para processamento distribuído e **Apache Flink** para detecção de anomalias em tempo real.

### 🎯 Business Case
Em cenários de Cibersegurança, detectar ataques de força bruta ou padrões de negação de serviço (DDoS) horas depois do ocorrido é inútil. Este projeto reduz o "Time-to-Insight" processando logs assim que eles chegam ao Data Lake (S3), identificando IPs maliciosos e gerando alertas automáticos.

## 🏗️ Arquitetura
```mermaid
flowchart LR
    %% Atores e Camadas Externas
    User([Engenheiro/Dev])
    Internet((Internet))

    %% Fronteira da AWS
    subgraph AWS [AWS Cloud: us-east-2]
        
        %% Camada de Rede
        subgraph VPC [VPC Privada]
            NAT[NAT Gateway]
            
            subgraph Private [Subnets Privadas]
                Lambda[Lambda Trigger]
                EMR[Cluster EMR]
            end
            
            Endpoint[VPC Endpoint S3]
        end

        %% Camada de Dados (S3)
        subgraph DataLake [Data Lake S3]
            Raw[Bucket Raw]
            Proc[Bucket Processed]
        end
    end

    %% Fluxo de Trabalho
    User -- 1. Upload Logs --> Raw
    Raw -- 2. Event Trigger --> Lambda
    Lambda -- 3. Submit Job --> EMR
    
    %% Fluxo de Processamento e Rede
    EMR -- Processamento --> EMR
    EMR <== 4. Leitura/Escrita Privada ==> Endpoint
    
    %% Conexão Endpoint -> Buckets
    Endpoint -.-> Raw
    Endpoint -.-> Proc

    %% Acesso Externo (Apenas Update)
    EMR -.-> NAT
    NAT -.-> Internet
```

A solução segue o padrão **Lakehouse** com foco em **Zero Trust Networking**:
1.  **Ingestion:** Amazon S3 (Raw Zone) com triggers via AWS Lambda.
2.  **Compute:** Cluster EMR efêmero com instâncias Spot (FinOps).
3.  **Security:** VPC Customizada com Subnets Privadas (sem acesso direto à internet).
    * VPC Endpoints para tráfego S3 (sem NAT Gateway para dados).
    * Criptografia em repouso (KMS) e trânsito (TLS).

## 🚀 Quick Start

### Pré-requisitos
* Docker e Docker Compose instalados.
* Credenciais AWS configuradas em `~/.aws/credentials`.

### Como Rodar (Ambiente Isolado)

Não é necessário instalar Terraform ou AWS CLI na sua máquina. Utilizamos um container "Toolbox" para garantir reprodutibilidade.

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
## 📚 Documentação Técnica

As Decisões de Arquitetura (ADRs) são mantidas junto ao código:

* [ADR-001: Estratégia de Networking e Segurança](docs/adr/001-networking.md)
