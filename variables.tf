data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

variable "aws_subnet" {
  description = "subnet where containers run"
  type        = string
}
variable "deploy_environment" {
  description = "type of environment a.k.a test/prod"
  type = string
}
variable "dbname" {
  description = "name of the db"
  type = string
}
variable "endpoint" {
  description = "database uri"
  type = string
}
variable "port" {
  description = "DB port"
  type = string
}
variable "prefix" {
  description = "used to identify infrastructure"
  type = string
}
variable "query" {
  description = "sql instruction to launch periodically"
  type = string
}
variable "retention_in_days" {
  default     = 30
  description = "how many days wait before deleting logs"
  type        = number
}
variable "role_arn" {
  description = "assumed to create infrastructure in enviroment where .hcl is ran"
  type        = string
}
variable "role_arn_lambda_name" {
  description = "role used by lambda"
  type        = string
}
variable "sc_lambda" {
  description = "Lambda security group"
  type = list(string)

}
variable "secret_name" {
  description = "name to use as parameter to be retrieved by ssm"
  type = string
}
variable "tag" {
  default = {
  }
  description = "tag to be added"
  type        = map(any)
}
variable "timeout" {
  description = "function timeout"
  type = number
  default = 3
}
variable "user" {
  description = "database user"
  type = string
}
variable "vpc_id" {
  description = "id representing AWS Virtual Private Cloud"
  type        = string
}
locals {
  region          = data.aws_region.current.name
  account_id      = data.aws_caller_identity.current.account_id
  role_prefix     = "arn:aws:iam::${local.account_id}:role/"
  role_arn_lambda = "${local.role_prefix}${var.role_arn_lambda_name}"
}
