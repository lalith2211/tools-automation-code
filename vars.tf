variable "tools" {
  default = {
    prometheus = {
      instance_type = "t3.micro"
      policy_resource_list = ["ec2:DescribeInstances"]
    }

    grafana = {
      instance_type = "t3.micro"
      policy_resource_list = []
    }

    vault = {
      instance_type = "t3.micro"
      policy_resource_list = []
    }

    elk = {
      instance_type = "r6i.large" #"r7i.large"
      policy_resource_list = []
    }

    ci-server = {
      instance_type = "t3.small"
      policy_resource_list = []
    }

#    sonarqube = {
#      instance_type = "t3.large"
#      policy_resource_list = []
#    }

    artifactory = {
      instance_type = "t3.large"
      policy_resource_list = []
    }
  }
}

variable "zone_id" {
  default = "Z08164623BYHI8XGQC72A"
}