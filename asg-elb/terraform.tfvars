aws_region = "us-east-2"
access_key = "somekey"
secret_key = "somekey"

image_id = "ami-0010d386b82bc06f0"
instance_type = "t2.micro"
key_name = "aws-workstation"
metric_name = "CPUUtilization"
alarm_period = "120"
alarm_namespace = "AWS/EC2"
up_threshold = "60"
down_threshold = "10"

http_port = 80
ssh_port = 22