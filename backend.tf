terraform {
  backend "s3" {
    bucket         = "nike-terraform-tfstate-file-bucket"
    key            = "vpcJenkinsServertfState/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
    # dynamodb       = {
    #   table_name = "terraform-locks"
    # }
  }
}