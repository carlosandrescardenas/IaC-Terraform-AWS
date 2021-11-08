#Security Group UI
resource "aws_security_group" "securitygroup_ui_carloscardenas_ec2" {
  name        = "securitygroup_ui_carloscardenas_ec2"
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
resource "aws_launch_template" "LT_frontend_ccardenas" {
  name = "LT_frontend_ccardenas"

  image_id      = "ami-083f68207d3376798"
  instance_type = "t1.micro"
  key_name      = "carloscardenas-ec2-ui.pem"

  vpc_security_group_ids = [aws_security_group.securitygroup_ui_carloscardenas_ec2.id]

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

  user_data = base64encode(templatefile("${path.module}/launchconfigurations/front.sh", {dns = aws_lb.lb_backend_carloscardenas.dns_name})) 
}

#load Balancer UI - Internet
resource "aws_lb" "lb_frontend_carloscardenas_inter" {
  name               = "lbfrontendcarloscardenasinter"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.securitygroup_ui_carloscardenas_ec2.id]
  subnets            = [data.aws_subnet.ramp_up_training-public-0.id, data.aws_subnet.ramp_up_training-public-1.id]

  enable_deletion_protection = false

  tags = {
    project     = var.tags.project
    responsible = var.tags.responsible
  }
}

#Target Group Load Balancer UI
resource "aws_lb_target_group" "tgroup_ccardenas_ui_internet" {
  name     = "tgroupccardenasuiinternet"
  port     = var.port_ui
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id
  tags = {
    project     = var.tags.project
    responsible = var.tags.responsible
  }
}

#Load Balancer Listener UI
resource "aws_lb_listener" "lbl_frontend_carloscardenas" {
  load_balancer_arn = aws_lb.lb_frontend_carloscardenas_inter.arn
  port              = var.port_ui
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tgroup_ccardenas_ui_internet.arn
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_ui_ccardenas" {
  autoscaling_group_name = aws_autoscaling_group.ag_frontend_carloscardenas.id
  alb_target_group_arn   = aws_lb_target_group.tgroup_ccardenas_ui_internet.arn
}

#AutoScaling group
resource "aws_autoscaling_group" "ag_frontend_carloscardenas" {
  vpc_zone_identifier = [data.aws_subnet.ramp_up_training-public-0.id, data.aws_subnet.ramp_up_training-public-1.id]
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size

  launch_template {
    id      = aws_launch_template.LT_frontend_ccardenas.id
    version = "$Latest"
  }

  tags = [{
    project = var.tags.project
    },
    {
      responsible = var.tags.responsible
  }]
}
