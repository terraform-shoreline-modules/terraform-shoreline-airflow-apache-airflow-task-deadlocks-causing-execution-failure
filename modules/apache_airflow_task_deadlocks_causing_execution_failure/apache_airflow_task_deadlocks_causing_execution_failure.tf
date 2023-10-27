resource "shoreline_notebook" "apache_airflow_task_deadlocks_causing_execution_failure" {
  name       = "apache_airflow_task_deadlocks_causing_execution_failure"
  data       = file("${path.module}/data/apache_airflow_task_deadlocks_causing_execution_failure.json")
  depends_on = [shoreline_action.invoke_timeout_task]
}

resource "shoreline_file" "timeout_task" {
  name             = "timeout_task"
  input_file       = "${path.module}/data/timeout_task.sh"
  md5              = filemd5("${path.module}/data/timeout_task.sh")
  description      = "Modify the task code to handle the deadlocking situation. This may involve adding a timeout function or implementing a retry mechanism."
  destination_path = "/tmp/timeout_task.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_timeout_task" {
  name        = "invoke_timeout_task"
  description = "Modify the task code to handle the deadlocking situation. This may involve adding a timeout function or implementing a retry mechanism."
  command     = "`chmod +x /tmp/timeout_task.sh && /tmp/timeout_task.sh`"
  params      = ["TASK_NAME","NAMESPACE"]
  file_deps   = ["timeout_task"]
  enabled     = true
  depends_on  = [shoreline_file.timeout_task]
}

