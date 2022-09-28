terraform {
  backend "s3" {
    bucket  = "vpc-assigment-mike-1234"
    key     = "VPC/project-1/project.tfstate"
    region  = "us-east-1"
    profile = "default"
  }
}
