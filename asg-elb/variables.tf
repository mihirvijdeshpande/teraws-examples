variable "aws_region" {
  description = "Region of AWS profile"
}
variable "access_key" {
  description = "Access Key"
}
variable "secret_key" {
  description = "Secret Key"
}

variable "instance_type" {
  description = "Type of EC2 instance"
}
variable "image_id" {
  description = "Image AMI ID"
}
variable "key_name" {
  description = "AWS Key Name"
}
variable "metric_name" {
  description = "Capacity of ASG"
}
variable "alarm_period" {
  description = "Period of Alarm"
}
variable "alarm_namespace" {
  description = "AWS Namespace"
}
variable "up_threshold" {
  description = "If CPU Utilisation goes above this, ASG will scale up"
}
variable "down_threshold" {
  description = "If CPU Utilisation drops below this, ASG will scale down"
}
variable "http_port" {
  description = "Port for HTTP"
}
variable "ssh_port" {
  description = "port for SSH"
}