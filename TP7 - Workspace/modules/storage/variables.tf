
variable "resource_group_name" {
  type = string
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
}

variable "account_name" {
  type = string
}

variable "container_name" {
  type = string
}