# Description
This directory contains the terraform code required to deploy the requested infrastructure.

It will deploy an autoscaling group with internet exit through a nat gateway. The incommig traffic will be received throug a network load balancer.
The instances will have read only access to an s3 bucket to download the assets as well as an rds cluster running postgres.

Not all variables have default values because these values cannot be easily defined, like the s3 bucket name (it has to be unique) or the ami (it's region dependent). An example terraform.tfvars is given as an example with all values defined.