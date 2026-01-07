import boto3
import os
import logging
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

emr = boto3.client('emr')

def lambda_handler(event, context):
    logger.info(">>> Evento Recebido:")
    logger.info(json.dumps(event))

    # 1. Captura Variaveis de Ambiente (Definidas no Terraform)
    cluster_id = os.environ.get('EMR_CLUSTER_ID')
    processed_bucket = os.environ.get('PROCESSED_BUCKET')

    if not cluster_id or not processed_bucket:
        logger.error("Variaveis de ambiente EMR_CLUSTER_ID ou PROCESSED_BUCKET nao definidas.")
        raise Exception("Configuracao invalida.")

        # 2. Processa cada arquivo que chegou
    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        file_key = record['s3']['object']['key']

        logger.info(f"Detectado arquivo: s3://{bucket_name}/{file_key}")

        # Monta os argumentos para o Spark
        input_uri = f"s3://{bucket_name}/{file_key}"
        output_uri = f"s3://{processed_bucket}/output/{file_key.split('/')[-1].replace('.txt', '')}"

        # 3. Adiciona o Step ao Cluster
        try:
            response = emr.add_job_flow_steps(
                JobFlowId=cluster_id,
                Steps=[
                    {
                        'Name': f'Process Log: {file_key}',
                        'ActionOnFailure': 'CONTINUE',
                        'HadoopJarStep': {
                            'Jar': 'command-runner.jar',
                            'Args': [
                                'spark-submit',
                                '--deploy-mode', 'cluster',
                                f's3://{bucket_name.replace("raw", "administrative")}/jobs/process_logs.py',
                                input_uri,
                                output_uri
                            ]
                        }
                    }
                ]
            )
            logger.info(f"Step adicionado com sucesso! StepIds: {response['StepIds']}")

        except Exception as e:
            logger.error(f"Erro ao adicionar step no EMR: {str(e)}")
            raise e

    return {
        'statusCode': 200,
        'body': json.dumps('Trigger processado com sucesso!')
    }