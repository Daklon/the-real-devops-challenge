resource "aws_launch_template" "main" {
  name_prefix            = "webserver"
  image_id               = var.asg_ami
  instance_type          = var.asg_instance_type
  user_data              = filebase64("${path.module}/install-web-server.sh")
  vpc_security_group_ids = [aws_security_group.autoscaling_group.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.main.arn
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_lb" "main" {
  name               = "lb-challenge-3"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
}



resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_autoscaling_group" "main" {
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  vpc_zone_identifier = [for subnet in aws_subnet.private : subnet.id]

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.main.arn]
}

resource "aws_cloudwatch_metric_alarm" "main" {
  alarm_name          = "more_than_50_packets_received"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "NetworkPacketsIn"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.scaling_threshold
  alarm_description   = "This alarm triggers when the number of network packets received by the Auto Scaling Group exceeds 50."

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  alarm_actions = [aws_autoscaling_policy.main.arn]
}

resource "aws_autoscaling_policy" "main" {
  name                   = "network_based_scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.main.name
}