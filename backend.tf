terraform {
  backend "s3" {
    bucket = "terraform-remote-cassandra"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
