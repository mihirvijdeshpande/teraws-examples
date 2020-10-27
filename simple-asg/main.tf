provider "aws" {
  region     = "us-east-2"
  access_key = "somekey"
  secret_key = "somekey"
}
resource "aws_launch_template" "alt" {
  name_prefix   = "alt"
  image_id      = "ami-0010d386b82bc06f0"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "asg" {
  availability_zones = ["us-east-2a"]
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  launch_template {
    id      = aws_launch_template.alt.id
    version = "$Latest"
  }
}
