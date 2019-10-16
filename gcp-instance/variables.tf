# https://www.terraform.io/docs/configuration/variables.html
variable "project" {
    type = string
    description = "The name of the google project"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "credentials_file" {}

variable "region" {
  default = "australia-southeast-1"
}

variable "zone" {
  default = "australia-southeast1-b"
}

variable "machine_types" {
  type = "map"
  default = {
    "dev" = "f1-micro"
    "test" = "n1-highcpu-32"
    "prod" = "n1-highcpu-32"
  }
}