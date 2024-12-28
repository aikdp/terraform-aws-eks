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

variable "backend_tags"{
    default = {
        Component = "backend"
    }
}

variable "zone_name"{
    default = "telugudevops.online"
}

variable "zone_id"{
    default = "Z0873413X28XY5FKMLIP"
}