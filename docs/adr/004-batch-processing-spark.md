# ADR-004: Adoção de Apache Spark para Processamento em Lote

* **Status:** Aceito
* **Data:** 2026-01-04
* **Contexto:**
Inicialmente, o projeto visava utilizar Apache Flink para processamento em tempo real. Contudo, nesta fase inicial de implementação da infraestrutura (IaC), o foco é validar a comunicação entre Storage (S3), Compute (EMR) e Networking (VPC).

A arquitetura de *Streaming* com Flink adiciona complexidade significativa de configuração e gestão de estado que foge do escopo atual de validação de infraestrutura.

## Decisão
Adotaremos **Apache Spark** como motor de processamento primário para esta fase.
* O Spark é nativo do EMR e possui integração transparente com S3.
* O foco será processamento **Batch** (Lote), que simplifica o desenvolvimento e testes iniciais. 
* O Apache Flink permanece no roadmap para uma fase futura de evolução para arquitetura Lambda/Kappa.

## Consequências
O código da aplicação será desenvolvido em **PySpark**. O README será atualizado para refletir o foco em Batch Processing.