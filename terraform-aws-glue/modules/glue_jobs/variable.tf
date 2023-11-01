variable "name" {
  description = "A name can be reused across resources in this module."
  type        = string
}

variable "env_prefix" {
  description = "Prefix for the S3 buckets"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    "project" : "fss-etl-framework"
    "environment" : "dev"
  }
}

variable "iam_glue_job_role" {
  description = "role used by glue jobs"
  type        = string
}

variable "artifacts_bucket_name" {
  description = "Artifacts bucket name"
  type = string
}

variable "temporary_bucket_name" {
  description = "Temporary bucket name for Glue job"
  type = string
}

variable "glue_jobs_filename" {
  description = "name of glue job json file"
  type        = string
}


variable "glue_cloudwatch_log_group" {
  description = "cloud watch log group for glue"
  type = string
}

variable "pip_pkg_bucket_name" {
  description = "Pip pkg bucket name"
  type = string
}
