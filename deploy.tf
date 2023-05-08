#resource "aws_scheduler_schedule" "lambda" {
#  name       = "schedule-lambda"
#  group_name = "default"
#
#  flexible_time_window {
#    mode = "OFF"
#  }
#  schedule_expression = "rate(1 minute)"
#  target {
#    arn      = aws_lambda_function.schedule.arn
#    role_arn = local.role_arn_lambda
#  }
#}

resource "aws_lambda_function" "schedule" {

  environment {
    variables = {
  DBNAME=var.dbname
  ENDPOINT=var.endpoint
  PORT=var.port
  QUERY=var.query
  REGION=local.region
  SECRET_NAME=var.secret_name
  USER=var.user
    }
  }

  filename      = "function.zip"
  function_name = "${var.prefix}-${var.deploy_environment}-schedule"
  handler       = "lambda_function.handler"
  # 0 disables
  reserved_concurrent_executions = 1
  role                           = local.role_arn_lambda
  runtime                        = "python3.8"
  source_code_hash               = filebase64sha256("function.zip")
  tags                           = var.tag
  timeout                         = var.timeout
  vpc_config {
    #because is used as a bash array variable elsewhere
    subnet_ids=split(",",trim(var.aws_subnet,"[]"))
    security_group_ids=var.sc_lambda
  }
}

