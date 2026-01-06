# Job teste para validar se o cluster consegue ler/escrever no S3
from pyspark.sql import SparkSession
from pyspark.sql.functions import regexp_extract, col, current_timestamp
import sys

def main():
    spark = (SparkSession.builder
             .appName("EMR Log Analytics - Batch ETL")
             .getOrCreate())

    if len(sys.argv) < 3:
        print("Uso: process_logs.py <input_uri> <output_uri>")
        sys.exit(1)

    input_path = sys.argv[1]
    output_path = sys.argv[2]

    print(f">>> Lendo dados de: {input_path}")
    print(f">>> Escrevendo dados em: {output_path}")

    # Lê o arquivo de texto bruto (raw). Cada linha vira uma string na coluna "value".
    raw_df = spark.read.text(input_path)

    # Regex para quebrar a linha do Apache Log em colunas
    regex_pattern = r'^(\S+) \S+ \S+ \[([\w:/]+\s[+\-]\d{4})\] "(\S+) (\S+)\s*(\S*)" (\d{3}) (\S+) ".*" "(.*)"'

    parsed_df = raw_df.select(
        regexp_extract('value', regex_pattern, 1).alias('client_ip'),
        regexp_extract('value', regex_pattern, 2).alias('timestamp'),
        regexp_extract('value', regex_pattern, 3).alias('method'),
        regexp_extract('value', regex_pattern, 4).alias('request'),
        regexp_extract('value', regex_pattern, 6).alias('status_code'),
        regexp_extract('value', regex_pattern, 7).alias('size'),
        regexp_extract('value', regex_pattern, 8).alias('user_agent')
    )

    # Adicionando data de processamento para controle e governança
    final_df = parsed_df.withColumn("processed_at", current_timestamp())

    print(">>> Preview dos dados transformados:")
    final_df.show(5, truncate=False)

    # Salvado em parquet, particionado pelo status_code, para otimizar as consultas
    (final_df.write
     .mode("overwrite")
     .partitionBy("status_code")
     .parquet(output_path))

    print(">>> ETL Finalizado com sucesso!")
    spark.stop()

if __name__ == "__main__":
    main()