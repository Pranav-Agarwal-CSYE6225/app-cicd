variable "aws_profile" {
    type = string
    description = "IAM user to use for deployment"
}

variable "aws_region" {
    type = string
    description = "Region to deploy in"
}

variable "iam_user" {
    type = string
    description = "iam user to give permissions to"
}

variable "aws_account" {
    type = string
    description = "aws account"
}

variable "application_name" {
    type = string
    description = "name of codedeploy app"
}