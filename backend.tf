terraform {
  backend "s3" {
    bucket         = "nike-main-bucket"
    key            = "vpcJenkinsServertfState/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
    # dynamodb       = {
    #   table_name = "terraform-locks"
    # }
  }
}