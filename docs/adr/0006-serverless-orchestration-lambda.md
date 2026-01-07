# 6. Orquestração de Jobs via AWS Lambda (Event-Driven)

* **Status:** Aceito
* **Data:** 2026-01-07
* **Responsável:** Lucas Galdino
* **Drivers da Decisão:**
    * Necessidade de automação imediata após a ingestão de dados (Real-time trigger).
    * Requisito de baixo custo operacional (sem servidores de orquestração ligados 24/7).
    * Simplicidade de implementação para triggers baseados em arquivo.

## Contexto
O cluster EMR precisa saber quando novos dados chegam ao bucket Raw para iniciar o processamento. As alternativas tradicionais seriam:
1.  **Polling:** Manter um script rodando em loop verificando o S3 (Ineficiente).
2.  **Agendamento (Cron):** Processar em horários fixos (Gera latência na disponibilidade do dado).
3.  **Orquestradores Pesados (Airflow/MWAA):** Custo elevado e complexidade de infraestrutura desnecessária para um único fluxo.

## Decisão
Adotamos uma arquitetura **Event-Driven** utilizando **AWS Lambda** acionado por **S3 Event Notifications**.
* O bucket S3 emite um evento `s3:ObjectCreated` sempre que um arquivo `.txt` entra na pasta `logs/`.
* Uma função Lambda captura esse evento, extrai o caminho do arquivo e submete um *Step* (Job Spark) ao cluster EMR via AWS SDK (`boto3`).

## Consequências
* **Positivo:** Custo zero enquanto não há dados (Serverless).
* **Positivo:** Latência mínima entre ingestão e início do processamento.
* **Positivo:** Desacoplamento total entre quem envia o arquivo e quem processa.
* **Negativo:** O Lambda tem um timeout máximo de 15 minutos (não afeta nosso caso pois ele apenas submete o job, não processa o dado).

## Links de Referência
* [AWS Lambda com Amazon S3](https://docs.aws.amazon.com/lambda/latest/dg/with-s3.html)
* [Boto3 EMR Client](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/emr.html#EMR.Client.add_job_flow_steps)