#VPC
data "aws_vpc" "ramp_up_training" {
  id      = var.aws_vpc_id
}

#Subnets associated to VPC ramp_up_training
data "aws_subnet" "ramp_up_training-public-0" {
  id = var.ramp_up_training_public_0_id
}

data "aws_subnet" "ramp_up_training-public-1" {
  id = var.ramp_up_training_public_1_id
}

data "aws_subnet" "ramp_up_training-private-0" {
  id = var.ramp_up_training_private_0_id
}

data "aws_subnet" "ramp_up_training-private-1" {
  id = var.ramp_up_training_private_1_id
}