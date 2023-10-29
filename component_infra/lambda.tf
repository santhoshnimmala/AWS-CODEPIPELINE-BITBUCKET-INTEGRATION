resource aws_lambda_function lambda_function_bit {
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "integration.handler"
  runtime          = "python3.9"
  filename         = "integration.zip"
  function_name    = "bitbucket_integrator"
  source_code_hash = filebase64sha256("integration.zip")
  kms_key_arn      = aws_kms_key.kms_key.arn
  environment {
    variables = {
      project_url = var.project_url
      s3_bucket = var.bucketname
      token = var.token


    }
  }
}
