variable "vpc_cidr_block" {}
variable "environment" {}
variable "public_subnet_1_cidr_block" {}
variable "public_subnet_2_cidr_block" {}
variable "private_subnet_1_cidr_block" {}
variable "private_subnet_2_cidr_block" {}
variable "subnet_availability_zone_1" {}
variable "subnet_availability_zone_2" {}
variable "connectivity_type" {
  default = "public"
}
variable "vpc_name" {}