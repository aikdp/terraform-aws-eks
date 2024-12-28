variable "vpc_cidr_kdp"{
    default = "10.0.0.0/16"
}

variable "project_name"{
    default = "expense"
}

variable "environment"{
    default = "dev"
}

variable "common_tags_vpc"{
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
    }
}

variable "subnet_public_cidrs"{
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnet_private_cidrs"{
    default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "subnet_database_cidrs"{
    default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "peering_required"{
    default = true
}