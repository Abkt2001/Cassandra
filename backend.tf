terraform {
  backend "s3" {
    bucket = "terraform-remote-cassandra" #Replace by your bucket name
    key    = "terraform/terraform.tfstate"  #foldername_name( created in bucket)/terraform.tfstate
    region = "us-east-1"
  }
}
