terraform {
  backend "s3" {
    bucket  = "prod-infra-tf"
    key     = "prod.tfstate"
    region  = "eu-central-1"
    profile = "disip"
  }
}
