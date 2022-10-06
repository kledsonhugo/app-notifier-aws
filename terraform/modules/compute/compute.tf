# RESOURCE: EC2 LAUNCH TEMPLATE

data "template_file" "user_data" {
    template = "${file("./modules/compute/scripts/user_data.sh")}"
    vars = {
        rds_endpoint      = "${var.rds_endpoint}"
        rds_dbuser        = "${var.rds_dbuser}"
        rds_dbpassword    = "${var.rds_dbpassword}"
        rds_dbname        = "${var.rds_dbname}"
        # access_key_id     = "${var.access_key_id}"
        # secret_access_key = "${var.secret_access_key}"
        # session_token     = "${var.session_token}"
    }
}

resource "aws_launch_template" "ec2_lt" {
    name                   = "${var.ec2_lt_name}"
    image_id               = "${var.ec2_lt_ami}"
    instance_type          = "${var.ec2_lt_instance_type}"
    key_name               = "${var.ec2_lt_ssh_key_name}"
    user_data              = "${base64encode(data.template_file.user_data.rendered)}"
    vpc_security_group_ids = ["${var.vpc_sg_pub_id}"]
}


# RESOURCE: APPLICATION LOAD BALANCER

resource "aws_lb" "ec2_lb" {
    name               = "${var.ec2_lb_name}"
    load_balancer_type = "application"
    subnets            = ["${var.vpc_sn_pub_az1_id}", "${var.vpc_sn_pub_az2_id}"]
    security_groups    = ["${var.vpc_sg_pub_id}"]
}

resource "aws_lb_target_group" "ec2_lb_tg" {
    name     = "${var.ec2_lb_tg_name}"
    protocol = "${var.ec2_lb_tg_protocol}"
    port     = "${var.ec2_lb_tg_port}"
    vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "ec2_lb_listener" {
    protocol          = "${var.ec2_lb_listener_protocol}"
    port              = "${var.ec2_lb_listener_port}"
    load_balancer_arn = aws_lb.ec2_lb.arn
    
    default_action {
        type             = "${var.ec2_lb_listener_action_type}"
        target_group_arn = aws_lb_target_group.ec2_lb_tg.arn
    }
}


# RESOURCE: AUTO SCALING GROUP

resource "aws_autoscaling_group" "ec2_asg" {
    name                = "${var.ec2_asg_name}"
    desired_capacity    = "${var.ec2_asg_desired_capacity}"
    min_size            = "${var.ec2_asg_min_size}"
    max_size            = "${var.ec2_asg_max_size}"
    vpc_zone_identifier = ["${var.vpc_sn_pub_az1_id}", "${var.vpc_sn_pub_az2_id}"]
    target_group_arns   = [aws_lb_target_group.ec2_lb_tg.arn]
    launch_template {
        id      = aws_launch_template.ec2_lt.id
        version = "$Latest"
    }
}