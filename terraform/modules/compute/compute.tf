resource "aws_security_group" "vpc_sg_pub" {
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("./modules/compute/scripts/user_data.sh")
  vars = {
    rds_endpoint   = "${var.rds_endpoint}"
    rds_dbuser     = "${var.rds_dbuser}"
    rds_dbpassword = "${var.rds_dbpassword}"
    rds_dbname     = "${var.rds_dbname}"
  }
}

resource "aws_launch_template" "ec2_lt" {
  name                   = var.ec2_lt_name
  image_id               = var.ec2_lt_ami
  instance_type          = var.ec2_lt_instance_type
  key_name               = var.ec2_lt_ssh_key_name
  user_data              = base64encode(data.template_file.user_data.rendered)
  vpc_security_group_ids = [aws_security_group.vpc_sg_pub.id]
}

resource "aws_lb" "ec2_lb" {
  name               = var.ec2_lb_name
  load_balancer_type = "application"
  subnets            = [var.vpc_sn_pub_az1_id, var.vpc_sn_pub_az2_id]
  security_groups    = [aws_security_group.vpc_sg_pub.id]
}

resource "aws_lb_target_group" "ec2_lb_tg" {
  name     = var.ec2_lb_tg_name
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "ec2_lb_listener" {
  protocol          = "HTTP"
  port              = 80
  load_balancer_arn = aws_lb.ec2_lb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
  }
}

resource "aws_autoscaling_group" "ec2_asg" {
  name                = var.ec2_asg_name
  desired_capacity    = var.ec2_asg_desired_capacity
  min_size            = var.ec2_asg_min_size
  max_size            = var.ec2_asg_max_size
  vpc_zone_identifier = [var.vpc_sn_pub_az1_id, var.vpc_sn_pub_az2_id]
  target_group_arns   = [aws_lb_target_group.ec2_lb_tg.arn]
  launch_template {
    id      = aws_launch_template.ec2_lt.id
    version = "$Latest"
  }
}