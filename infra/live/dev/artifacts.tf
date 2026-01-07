# Upload do script de bootstrap
resource "aws_s3_object" "bootstrap_script" {
  bucket = module.storage.bucket_names["administrative"]
  key    = "scripts/init.sh"
  source = "../../../src/bootstrap/init.sh"

  # Hash MD5: para que o terraform só faça upload caso o conteúdo mude, e não a cada terraform apply
  etag = filemd5("../../../src/bootstrap/init.sh")
}

# Upload do job Spark
resource "aws_s3_object" "spark_job" {
  bucket = module.storage.bucket_names["administrative"]
  key    = "jobs/process_logs.py"
  source = "../../../src/jobs/spark/process_logs.py"
  etag   = filemd5("../../../src/jobs/spark/process_logs.py")
}