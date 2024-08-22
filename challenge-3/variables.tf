variable "vpc_cidr" {
  description = "the vpc cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "list of subnets"
}

variable "bucket_name" {
  description = "Name for the s3 bucket"
}

variable "asg_instance_type" {
  description = "Instance type for the autoscaling group"
  default     = "t3.micro"
}

variable "asg_ami" {
  description = "ami to be used by the autoscaling group instances"
}

variable "asg_desired_capacity" {
  description = "desired capacity for the autoscaling group instances"
}

variable "asg_max_size" {
  description = "max size for the autoscaling group instances"
}

variable "asg_min_size" {
  description = "min size the autoscaling group instances"
}

variable "scaling_threshold" {
  description = "Number of packets received to scale the autoscalling group"
  type        = string
  default     = "50"
}

variable "rds_engine_version" {
  description = "postgres version"
  type        = string
  default     = "16.4"
}

variable "rds_instance_class" {
  description = "intance type to be used by the rds cluster"
  type        = string
  default     = "db.c6gd.medium"
}

variable "rds_allocated_storage" {
  description = "size in gb for the db storage"
  default     = 100
}

variable "rds_master_username" {
  description = "username for the rds cluster"
  default     = "dbuser"
}