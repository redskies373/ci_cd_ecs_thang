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
variable "runner_ami" {
    type        = string
}
variable "runner_instance_type" {
    type        = string
    default     = "t3.nano"
}
variable "task_def_file_name" {
    type        = string
    default     = "task-definition.json"
}