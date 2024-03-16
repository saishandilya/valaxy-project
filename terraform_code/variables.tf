# variable "s3bucket" {
#     description = "s3 bucket name to store backend configuration"
# }

variable "vpccidr" {
    description = "value for the vpc cidr"
}

variable "vpcpub1subcidr" {
    description = "value for the public subnet 1 cidr"
}

variable "vpcpub2subcidr" {
    description = "value for the public subnet 2 cidr"
}

variable "vpcsgcidrblocks" {
    description = "value of sg cidr block"
    type    = list(string)
    # default = ["0.0.0.0/0"]
}

variable "ami" {
    description = "value for the ami"
}

variable "instancetype" {
  description = "value of the instance type"
}

variable "keyname" {
  description = "value of the key pair"
}