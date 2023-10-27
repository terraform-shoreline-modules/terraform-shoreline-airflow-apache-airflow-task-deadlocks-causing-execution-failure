terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "apache_airflow_task_deadlocks_causing_execution_failure" {
  source    = "./modules/apache_airflow_task_deadlocks_causing_execution_failure"

  providers = {
    shoreline = shoreline
  }
}