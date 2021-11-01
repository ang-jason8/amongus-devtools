variable "name" {
  type    = string
  default = "amoungus-devtools"
}

locals {
  ami_id        = "ami-0f511ead81ccde020"
  instance_type = "t2.micro"
}

resource "aws_instance" "app_server" {
  ami           = local.ami_id
  instance_type = local.instance_type

  # to add keypain
  key_name = "jasondevtools"

  # assign security groups

  security_groups = [aws_security_group.allow_ssh.name, aws_security_group.allow_https.name, aws_security_group.allow_http.name]

  tags = {
    # Name = local.uniq_id
    Name = var.name
  }
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH to app server"
  #   vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "Allow SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  #   egress = [
  #     {
  #       from_port        = 0
  #       to_port          = 0
  #       protocol         = "-1"
  #       cidr_blocks      = ["0.0.0.0/0"]
  #       ipv6_cidr_blocks = ["::/0"]
  #       prefix_list_ids  = []
  #       security_groups  = []
  #       self             = false
  #     }
  #   ]

  tags = {
    Name = "allow_ssh"
  }
}


resource "aws_security_group" "allow_https" {
  name        = "allow_https"
  description = "Allow TLS inbound traffic"
  #   vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "TLS traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "TLS traffic outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "allow_https_tls"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  #   vpc_id      = aws_vpc.main.id

  ingress = [
    {
      description      = "http traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "http outbound"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]


  tags = {
    Name = "allow_http"
  }
}

output "instance_security_groups" {
  value = [aws_instance.app_server.security_groups]
}

output "instance_ips" {
  value = [aws_instance.app_server.public_ip]
}

output "instance_ids" {
  value = [aws_instance.app_server.id]
}