# ADR 002: Estratégia de Armazenamento e Camadas de Dados (S3)

* **Status:** Aceito
* **Data:** 2026-01-02
* **Responsável:** Lucas Galdino
* **Drivers da Decisão:** Segurança de Dados, Durabilidade, Organização Logística

## Contexto
A plataforma de Log Analytics precisa de um local persistente e escalável para armazenar logs brutos, resultados processados e artefatos de execução (scripts/jars). O uso de armazenamento efêmero dentro do cluster EMR (HDFS) é desencorajado para persistência de longo prazo devido ao custo e à volatilidade do cluster.

## Decisão
Implementaremos uma estrutura de **Data Lakehouse baseada em Amazon S3**, dividida em buckets lógicos com políticas de segurança rigorosas.

### 1. Camadas de Dados (Buckets)
* **Raw (bronze):** Armazenamento de logs imutáveis em seu estado original.
* **Processed:** Resultados da análise do Flink (ex: IPs detectados, agregações).
* **Administrative:** Scripts de bootstrap, arquivos JAR do Flink e logs de depuração do próprio EMR.

### 2. Hardening de Segurança (Segurança por Padrão)
* **Block Public Access:** Todos os buckets terão bloqueio total de acesso público via ACLs ou Policy.
* **Criptografia:** Ativação de *Server-Side Encryption* (SSE-S3) por padrão para todos os objetos.
* **Versionamento:** Ativado no bucket de *Scripts* para evitar perda acidental de código de produção.

### 3. Convenção de Nomenclatura
Os buckets seguirão o padrão `<projeto>-<ambiente>-<função>-<regiao>-<random_id>`, garantindo unicidade global e facilidade de identificação.

## Consequências
* **Positiva:** Isolamento total dos dados (o dado processado nunca se mistura com o bruto).
* **Positiva:** Conformidade com LGPD/GDPR ao garantir criptografia e bloqueio público.
* **Negativa:** Maior complexidade na gestão de permissões IAM (será necessário dar permissões específicas para cada camada).

## Referências
* [Melhores práticas de segurança para o Amazon S3](https://docs.aws.amazon.com/pt_br/AmazonS3/latest/userguide/security-best-practices.html)
* [Proteção de dados com criptografia do lado do servidor (SSE-S3)](https://docs.aws.amazon.com/pt_br/AmazonS3/latest/userguide/UsingServerSideEncryption.html)
* [Bloquear o acesso público ao armazenamento do Amazon S3](https://docs.aws.amazon.com/pt_br/AmazonS3/latest/userguide/access-control-block-public-access.html)