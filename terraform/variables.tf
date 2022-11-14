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
variable "gha_repo" {
    type        = string
    default     = "ci_cd_ecs_thang"
}
variable "ecs_repo" {
    type        = string
    default     = "github-actions"
}
variable "container_port" {
    type        = number
    default     = 8080
}
variable "container_cpu" {
    type        = number
    default     = 256
}
variable "container_memory" {
    type        = number
    default     = 512
}