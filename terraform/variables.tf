variable "region" {
    type        = string
}
variable "vpc_id" {
    type        = string
}
variable "subnets" {
    type        = list
    description = "Subnet Id's"
}
variable "dns_zone_id" {
    type        = string
}
variable "task_role_arn" {
    type        = string
}