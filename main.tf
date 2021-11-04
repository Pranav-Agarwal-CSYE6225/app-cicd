provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_iam_policy" "GH-Upload-To-S3" {
  name        = "GH-Upload-To-S3"
  description = "AMI Policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::codedeploy.randomstring123",
                "arn:aws:s3:::codedeploy.randomstring123/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "GH-Code-Deploy" {
  name        = "GH-Code-Deploy"
  description = "AMI Policy"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetApplicationRevision"
      ],
      "Resource": [
        "arn:aws:codedeploy:${var.aws_region}:${var.aws_account}:application:${var.application_name}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource": [
        "arn:aws:codedeploy:${var.aws_region}:${var.aws_account}:deploymentconfig:CodeDeployDefault.AllAtOnce"
      ]
    }
  ]
}
EOF
}

data "aws_iam_user" "gh-cicd" {
  user_name = var.iam_user
}

resource "aws_iam_user_policy_attachment" "GH_Code_Deploy" {
  user       = data.aws_iam_user.gh-cicd.user_name
  policy_arn =  aws_iam_policy.GH-Code-Deploy.arn
}

resource "aws_iam_user_policy_attachment" "GH_Upload_To_S3" {
  user       = data.aws_iam_user.gh-cicd.user_name
  policy_arn =  aws_iam_policy.GH-Upload-To-S3.arn
}