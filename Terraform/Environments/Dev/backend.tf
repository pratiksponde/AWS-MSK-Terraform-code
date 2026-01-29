terraform {
  backend "s3" {
    bucket         = "Update-your-bucket-name"
    key     = "msk/dev/terraform.tfstate"    # Create this folders in S3 bucket
    region         = "Update-your-region-name"
    use_lockfile  = true
  }
}