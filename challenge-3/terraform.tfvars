subnets = {
  private ={
    a = {
      az = "eu-west-2a"
      cidr = "10.0.0.0/24"
    }
    b = {
      az = "eu-west-2b"
      cidr = "10.0.10.0/24"
    }
    c = {
      az = "eu-west-2c"
      cidr = "10.0.20.0/24"
    }
  }
  public = {
    a = {
      az = "eu-west-2a"
      cidr = "10.0.1.0/24"
    }
    b = {
      az = "eu-west-2b"
      cidr = "10.0.11.0/24"
    }
    c = {
      az = "eu-west-2c"
      cidr = "10.0.21.0/24"
    }
  }
}

bucket_name = "daklon-challenge-3"
asg_ami = "ami-07c1b39b7b3d2525d"
asg_desired_capacity = 1
asg_max_size = 3
asg_min_size = 1
