variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t3.small"
}

variable "key_name" {
  description = "EC2 Key Pair for SSH"
  type        = string
}

variable "couchbase_nodes" {
  default = 3
}
