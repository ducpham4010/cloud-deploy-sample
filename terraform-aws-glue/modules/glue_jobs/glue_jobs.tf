locals {
  glue_jobs_lists = jsondecode(file("${path.root}/${var.glue_jobs_filename}"))
}

resource "aws_glue_job" "this" {
  count                  = length(local.glue_jobs_lists.*.GlueJobName)
  name                   = format("%s-%s-glue-jb-%s", var.name, var.env_prefix, element(local.glue_jobs_lists.*.GlueJobName, count.index))
  role_arn               = var.iam_glue_job_role
  glue_version           = local.glue_jobs_lists[count.index]["Type"] == "glueetl" ? local.glue_jobs_lists[count.index]["Glue_Version"] : null

  number_of_workers      = local.glue_jobs_lists[count.index]["Type"] == "glueetl" ? (lookup(local.glue_jobs_lists[count.index], "Number_Of_Workers", "") != "" ? local.glue_jobs_lists[count.index].Number_Of_Workers : 2) : null
  worker_type            = local.glue_jobs_lists[count.index]["Type"] == "glueetl" ? lookup(local.glue_jobs_lists[count.index], "Worker_Type", "G.1X") : null
  max_capacity           = local.glue_jobs_lists[count.index]["Type"] == "pythonshell" ? local.glue_jobs_lists[count.index]["MaxCapacity"] : null
  execution_property {
    max_concurrent_runs = element(local.glue_jobs_lists.*.Max_Concurrent_Runs, count.index)
  }
  command {
    name            = element(local.glue_jobs_lists.*.Type, count.index)
    script_location = format("s3://%s/etl_framework/glue_scripts/%s", var.artifacts_bucket_name, element(local.glue_jobs_lists.*.Glue_Script_FileName, count.index))
    python_version  = lookup(local.glue_jobs_lists[count.index], "Python_Version", "") != "" ? element(local.glue_jobs_lists.*.Python_Version, count.index) : null
  }
  default_arguments = {
    "--TempDir"                          = "s3://${var.temporary_bucket_name}/glue_temporary/"
    "--continuous-log-logGroup"          = var.glue_cloudwatch_log_group
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = "true"
    "--enable-glue-datacatalog"          = lookup(local.glue_jobs_lists[count.index], "EnableGlueDataCatalog", false) ? true : null
    "--extra-py-files"                   = lookup(local.glue_jobs_lists[count.index], "Python_Lib", "") != "" ? format("s3://%s/etl_framework/glue_libs/%s", var.artifacts_bucket_name, element(local.glue_jobs_lists.*.Python_Lib, count.index)) : null
    "--additional-python-modules"        = length(trimspace(element(local.glue_jobs_lists.*.Python_Pip_Lib, count.index))) > 0 ? join(",", formatlist("s3://%s/etl_framework/pip_pkg/%s", var.artifacts_bucket_name, split(",",element(local.glue_jobs_lists.*.Python_Pip_Lib, count.index)))) : null
    "--conf"                             = "spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog --conf spark.sql.catalog.glue_catalog.warehouse=s3://${var.artifacts_bucket_name}/golden_curated --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO --conf spark.sql.catalog.glue_catalog.glue.skip-name-validation=true --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions --conf spark.sql.parquet.enableVectorizedReader=true --conf spark.sql.catalog.glue_catalog.cache-enabled=false --conf spark.sql.iceberg.handle-timestamp-without-timezone=true"
    "--datalake-formats"                 = "iceberg"
  }
  tags = merge(
    {
      "Name" = format("%s-%s", var.name, element(local.glue_jobs_lists.*.GlueJobName, count.index))
    },
    var.tags
  )
}