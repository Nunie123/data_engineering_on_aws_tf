variable "environment" {}
variable "allocated_storage" {}
variable "max_allocated_storage" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "name" {}
variable "skip_final_snapshot" {
    type = bool
}
variable "enabled_cloudwatch_logs_exports" {
    type = list
}
variable "subnet_ids" {
    type = list
}
variable "security_group_ids" {
    type = list
}