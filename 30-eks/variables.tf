
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



variable "ingress_alb_sg_tags"{
    default = {
        Component = "ingress-alb"
    }
}