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
variable "gha_user" {
    type        = string
    default     = "github-actions"
}
variable "gha_repo" {
    type        = string
    default     = "ci_cd_ecs_thang"
}