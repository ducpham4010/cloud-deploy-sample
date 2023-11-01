provider "aws" {
  region  = "ap-southeast-1"
  profile = "deploy"
}

module "glue_jobs_python" {
  source = "./modules/glue_jobs/"

  name                      = "fss"
  env_prefix                = "dev"
  iam_glue_job_role         = "arn:aws:iam::039178755962:role/fss-ap-southeast-1-jb-glue-role"
  glue_jobs_filename        = "glue_jobs_python.json"
  artifacts_bucket_name     = "fss-data-dev-artifacts-ap-southeast-1-039178755962"
  temporary_bucket_name     = "aws-glue-assets-039178755962-ap-southeast-1"
  pip_pkg_bucket_name       = "fss-data-dev-artifacts-ap-southeast-1-039178755962"
  glue_cloudwatch_log_group = "glue_jobs"
}