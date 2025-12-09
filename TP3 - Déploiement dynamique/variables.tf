variable "web_server_port" {
  type        = string
  description = "The port the server will use for HTTP requests"
  default     = "80"
}



variable "instance_template" {
  type        = string
  description = "Template for the webserver"
  default     = "Standard_B1s"
}
