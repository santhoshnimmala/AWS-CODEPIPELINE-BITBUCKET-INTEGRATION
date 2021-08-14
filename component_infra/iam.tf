resource "aws_iam_policy" "ima_lambda_function_kms_s3" {
  name = "iam_lambda_function_kms_s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:PutObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.bucket_for_artifacts.arn}"
      },
      {
        Action   = ["s3:PutObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.bucket_for_artifacts.arn}/*"
      },
      {
        Action   = ["kms:decrypt"]
        Effect   = "Allow"
        Resource = "${aws_kms_key.kms_key.arn}"
      },
    ]
  })
}

resource "aws_iam_role" "lambda_exec_role" {
  name                = "lambda_exec_role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_policy.json 
  managed_policy_arns = [aws_iam_policy.ima_lambda_function_kms_s3.arn,"arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]
}

data "aws_iam_policy_document" "lambda_assume_policy"{

    statement{
        actions=["sts:AssumeRole"]
        effect = "Allow"
       
       principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
       }
}
}