## ============
#  Variables#
## ============
variable "aws_region" {
  type        = string
  description = "Default region for root module"
  default     = "us-west-1"
}

variable "aws_vpc_id" {
  type        = string
  description = "id vpc module"
  default     = "vpc-0d2831659ef89870c"
}

variable "ramp_up_training_public_0_id" {
  type        = string
  description = "ramp_up_training_public_0_id"
  default     = "subnet-0088df5de3a4fe490"
}

variable "ramp_up_training_public_1_id" {
  type        = string
  description = "ramp_up_training_public_0_id"
  default     = "subnet-055c41fce697f9cca"
}

variable "ramp_up_training_private_0_id" {
  type        = string
  description = "ramp_up_training_private_0_id"
  default     = "subnet-0d74b59773148d704"
}

variable "ramp_up_training_private_1_id" {
  type        = string
  description = "ramp_up_training_private_1_id"
  default     = "subnet-038fa9d9a69d6561e"
}

variable "tags" {
  type        = map(string)
  description = "tags"
  default = {
    project     = "ramp-up-devops"
    responsible = "carlos.cardenasp"
  }
}

variable "desired_capacity" {
  type        = number
  description = "desired_capacity"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "max_size"
  default     = 1
}

variable "min_size" {
  type        = number
  description = "min_size"
  default     = 1
}

variable "port_ui" {
  type        = number
  description = "port_ui"
  default     = 8080
}

variable "port_back" {
  type        = number
  description = "port_back"
  default     = 8085
}