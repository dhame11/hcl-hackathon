resource "aws_s3_bucket" "backend" {
  bucket = "terraform-backend-bucket"
}
resource "aws_dynamodb_table" "terraform-lock" {
    name           = "terraform_state"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
  }
terraform {
  backend "s3" {
    bucket = "terraform-backend-bucket"
    key    = "tfbacked/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}
