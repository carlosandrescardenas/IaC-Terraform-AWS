#Security Group Back
resource "aws_security_group" "securitygroup-api-carloscardenas-ec2" {
  name        = "securitygroup-api-carloscardenas-ec2"
  description = "Allow traffic for API side"
  vpc_id      = var.aws_vpc_id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    project     = var.tags.project
    responsible = var.tags.responsible
  }
}

#Launch Template
resource "aws_launch_template" "LT-backend-ccardenas" {
  name = "LT-backend-ccardenas"

  image_id      = "ami-083f68207d3376798"
  instance_type = "t1.micro"
  key_name      = "carloscardenas-ec2-api"

  vpc_security_group_ids = [aws_security_group.securitygroup-api-carloscardenas-ec2.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      project     = var.tags.project
      responsible = var.tags.responsible
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      project     = var.tags.project
      responsible = var.tags.responsible
    }
  }

  user_data = base64encode("${data.template_file.userdata_back.rendered}") 
}

data "template_file" "userdata_back" {
  template = file("${path.module}/launchconfigurations/back.sh")
  vars = {
    endpoint = "${aws_db_instance.moviedb_ccardenas.endpoint}"
  }
}

#load Balancer API - Internet
resource "aws_lb" "lb-backend-carloscardenas" {
  name               = "lb-backend-carloscardenas"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.securitygroup-api-carloscardenas-ec2.id]
  subnets            = [data.aws_subnet.ramp_up_training-private-0.id, data.aws_subnet.ramp_up_training-private-1.id]

  enable_deletion_protection = false

  tags = {
    project     = var.tags.project
    responsible = var.tags.responsible
  }
}

#Target Group Load Balancer API
resource "aws_lb_target_group" "targetgroupBackendCarlosCardenas" {
  name     = "targetgroupBackendCarlosCardenas"
  port     = var.port_back
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id
  tags = {
    project     = var.tags.project
    responsible = var.tags.responsible
  }
}

#Load Balancer Listener API
resource "aws_lb_listener" "lbl-backend-carloscardenas" {
  load_balancer_arn = aws_lb.lb-backend-carloscardenas.arn
  port              = var.port_back
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgroupBackendCarlosCardenas.arn
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_api_ccardenas" {
  autoscaling_group_name = aws_autoscaling_group.ag-backend-carloscardenas.id
  alb_target_group_arn   = aws_lb_target_group.targetgroupBackendCarlosCardenas.arn
}

#AutoScaling group
resource "aws_autoscaling_group" "ag-backend-carloscardenas" {
  vpc_zone_identifier = [data.aws_subnet.ramp_up_training-private-0.id, data.aws_subnet.ramp_up_training-private-1.id]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  launch_template {
    id      = aws_launch_template.LT-backend-ccardenas.id
    version = "$Latest"
  }

  tags = [{
    project = var.tags.project
    },
    {
      responsible = var.tags.responsible
  }]
}

