variable "vpc_cidr_kdp"{
    default = "10.0.0.0/16"
}

variable "project_name"{
    default = "expense"
}

variable "environment"{
    default = "dev"
}

variable "common_tags"{
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "bastion_tags"{
    default = {
        Component = "bastion"
    }
}