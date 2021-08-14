terraform {
  backend "s3" {
    bucket = "backend-bucket-name"
    key    = "integxxration/terraform.tfstate"
    region = "eu-central-1"
  }
}