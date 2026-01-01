# ADR 001: Estratégia de Networking e Segurança

* **Status:** Aceito
* **Data:** 2026-01-01
* **Responsável:** Lucas Galdino
* **Drivers da Decisão:** Segurança (Zero Trust), Otimização de Custos (FinOps), AWS Well-Architected Framework

## Contexto
No desenvolvimento deste projeto de portfólio para análise de logs, identificou-se a necessidade de processar dados sensíveis simulados. A configuração padrão da AWS (Default VPC) ou designs simplistas posicionam recursos de computação (EMR) em subnets públicas, o que expõe portas de gerenciamento à internet aberta.

Além disso, o tráfego de grandes volumes de dados entre EC2 e S3 via NAT Gateway gera custos desnecessários e latência.

## Decisão
A decisão arquitetural é implementar uma **VPC Customizada com Isolamento de Camadas**, priorizando segurança e eficiência de custos, mesmo em um ambiente de demonstração.

### 1. Segmentação de Subnets
* **Public Subnets:** Apenas para recursos que exigem tráfego de entrada da internet (ex: Load Balancers, NAT Gateways etc).
* **Private Subnets:** Onde residem o Cluster EMR e as Funções Lambda. Sem rota direta de entrada da internet.

### 2. VPC Endpoints
Para comunicação com o S3, utilizarei **VPC Gateway Endpoints**.
* **Motivação:** Evitar que o tráfego de dados passe pelo NAT Gateway (redução de custo) ou pela internet pública (segurança).

## Consequências
* **Positiva:** Aderência às práticas de segurança corporativas (Cluster inacessível externamente).
* **Positiva:** Redução de custos de Data Transfer Out.
* **Negativa:** Acesso para debug torna-se mais complexo, exigindo o uso de AWS Systems Manager (SSM) em vez de SSH direto.

## Referências
* [AWS Well-Architected Framework - Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
* [EMR Management Guide - Best Practices](https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-plan-vpc-subnet.html)