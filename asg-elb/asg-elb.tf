resource "aws_launch_configuration" "webcluster" {
  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.websg.id]
  key_name        = var.key_name
  user_data       = <<-EOF
    #!/bin/bash
    echo "Hello!! This is WebService!" > index.html
    nohup busybox httpd -f -p 80 &
    EOF
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "scalegroup" {
  launch_configuration = aws_launch_configuration.webcluster.name
  availability_zones   = ["${var.aws_region}a"]
  min_size             = 1
  max_size             = 2
  enabled_metrics      = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  metrics_granularity  = "1Minute"
  load_balancers       = [aws_elb.elb1.id]
  health_check_type    = "ELB"
}
resource "aws_autoscaling_policy" "autopolicy" {
  name                   = "teraws-autopolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.scalegroup.name
}
resource "aws_cloudwatch_metric_alarm" "cpualarm" {
  alarm_name          = "teraws-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = var.metric_name
  namespace           = var.alarm_namespace
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.up_threshold
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.scalegroup.name
  }
  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.autopolicy.arn]
}
resource "aws_autoscaling_policy" "autopolicy-down" {
  name                   = "terraform-autoplicy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.scalegroup.name
}
resource "aws_cloudwatch_metric_alarm" "cpualarm-down" {
  alarm_name          = "terraform-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = var.metric_name
  namespace           = var.alarm_namespace
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.down_threshold

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.scalegroup.name
  }

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.autopolicy-down.arn]
}
resource "aws_security_group" "websg" {
  name = "security_group_for_web_server"
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.websg.id
  type              = "ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group" "elbsg" {
  name = "security_group_for_elb"
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_elb" "elb1" {
  name               = "terraform-elb"
  availability_zones = ["${var.aws_region}a"]
  security_groups    = [aws_security_group.elbsg.id]

  listener {
    instance_port     = var.http_port
    instance_protocol = "http"
    lb_port           = var.http_port
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

}
resource "aws_lb_cookie_stickiness_policy" "cookie_stickness" {
  name                     = "cookiestickness"
  load_balancer            = aws_elb.elb1.id
  lb_port                  = var.http_port
  cookie_expiration_period = 600
}

output "elb-dns" {
  value = aws_elb.elb1.dns_name
}
