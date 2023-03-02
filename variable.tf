variable "profile" {
  type    = string
  default = "Rick"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_blocks" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cidr_blocks_defualt" {
  type    = string
  default = "0.0.0.0/0"
}

variable "public_cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidr_blocks" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "name_prefix" {
  type    = list(string)
  default = ["web", "app", "data"]
}
