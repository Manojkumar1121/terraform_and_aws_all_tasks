terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-254408268883-ap-south-1-an"
    key            = "vpc/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile   = true
    encrypt        = true
  }
}