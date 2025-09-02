# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security group
resource "aws_security_group" "couchbase_sg" {
  name        = "couchbase-sg"
  description = "Allow Couchbase cluster ports"
  vpc_id      = data.aws_vpc.default.id

  # Couchbase Web Console - open to all
  ingress {
    from_port   = 8091
    to_port     = 8091
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Intra-cluster communication (Couchbase nodes only)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound - allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2s
resource "aws_instance" "couchbase_nodes" {
  count         = var.couchbase_nodes
  ami           = "ami-0885b1f6bd170450c" 
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = [aws_security_group.couchbase_sg.id]

  tags = {
    Name = "couchbase-node-${count.index + 1}"
  }
}

