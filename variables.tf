variable "server_port" {
  description = "The port the server sill use for HTTP requests"
  type = number
  default = "8080"
}

variable "instancetype" {
  type = string
  description = "set aws instance type"
  default = "t2.micro"
}