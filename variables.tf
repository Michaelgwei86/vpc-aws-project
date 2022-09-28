variable "public-subnet-cidrs" {

  type        = list(any)
  description = "Public subnet CIDR values"
  default     = ["10.0.1.0/24"]
}

variable "private-subnet-cidrs" {

  type        = list(any)
  description = "Private subnet CIDR values"
  default     = ["10.0.2.0/24"]
}

variable "azs" {

  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "instance_type" {
  default = ["t2.micro"]
}

variable "ami_ids" {
  default = {
    0 = "ami-026b57f3c383c2eec"
  }
}

variable "sg_ports" {
  type        = list(string)
  description = "list of ingress ports"
  default     = [443, 80]
}

