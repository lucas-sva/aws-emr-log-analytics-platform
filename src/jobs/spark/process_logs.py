# Job teste para validar se o cluster consegue ler/escrever no S3
from pyspark.sql import SparkSession
import sys
import datetime

def main():
    spark = (SparkSession
             .builder
             .appName("EMR Log Analytics - Infra Test")
             .getOrCreate())

    # Cria dados fake em memória
    data = [("Log_001", "INFO"), ("Log_002", "ERROR")]
    columns = ["log_id", "level"]
    df = spark.createDataFrame(data, columns)

    print(">>> DataFrame de teste criado:")
    df.show()

    # Teste de Escrita no S3 (Valida IAM Roles)
    if len(sys.argv) > 1:
        output_path = sys.argv[1]
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")

        print(f">>> Testando escrita em: {output_path}")
        df.write.mode("overwrite").parquet(f"{output_path}/smoke_test_{timestamp}")
    else:
        print(">>> NENHUM bucket de saída fornecido. Pulando escrita.")

    spark.stop()

if __name__ == "__main__":
    main()