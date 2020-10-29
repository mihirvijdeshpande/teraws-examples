resource "aws_launch_template" "alt" {
  name_prefix   = var.template_name
  image_id      = var.image_id
  instance_type = var.instance_type
}

resource "aws_autoscaling_group" "asg" {
  availability_zones = [var.aws_region]
  desired_capacity   = var.capacity
  max_size           = var.capacity
  min_size           = var.capacity

  launch_template {
    id      = aws_launch_template.alt.id
    version = "$Latest"
  }
}
