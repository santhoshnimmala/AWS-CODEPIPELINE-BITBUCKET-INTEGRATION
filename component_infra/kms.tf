
resource aws_kms_key "kms_key"{
    description = "KMS key for lambda"
    policy = data.aws_iam_policy_document.policy_iam_lambda.json
}

data "aws_iam_policy_document" "policy_iam_lambda"{

    statement{
        sid = "Enable IAM policy for account"
        actions=[
            "kms:*",
        ]
        effect = "Allow"
        principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
        
        resources = ["*"]
    }
}



