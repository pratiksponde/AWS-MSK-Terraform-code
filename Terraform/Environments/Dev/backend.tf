terraform {
  backend "s3" {
    bucket         = "my-terraform-state-buckett1"
    key     = "msk/dev/terraform.tfstate"
    region         = "us-east-1"
    #dynamodb_table = "terraform-locks"
    #encrypt        = true
    use_lockfile  = true
  }
}