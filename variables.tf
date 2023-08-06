variable "region" {
  default = "us-east-1"
}

variable "key_name" {
  type = string
  default = "halil"
}

variable "instancetype" {
  type = string
  default = "t3a.medium"
}

variable "myami" {
  description = "Ubuntu 20.04 ami"
  default     = "ami-0261755bbcb8c4a84"
}

variable "sifre" {
  default = "123456789"
}
variable "url" {
  default = "url"
}