/*
Before using the terraform backend always create an s3 bucket and use it name here
*/

terraform {
  backend "s3" {
    bucket = "valaxy-terraform-backend" # Replace with your bucket name
    key    = "valaxy/terraform.tfstate" # Replace with your folder name
    region = "us-east-1"
  }
}
