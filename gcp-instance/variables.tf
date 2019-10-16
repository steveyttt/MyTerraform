# https://www.terraform.io/docs/configuration/variables.html
variable "project" {}

variable "credentials_file" {}

variable "region" {
  default = "australia-southeast-1"
}

variable "zone" {
  default = "australia-southeast1-b"
}
