variable "base_ami" { default = "ami-1aa1e370" }
variable "public_key_path" { default = "~/.ssh/id_rsa.pub" }

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "tfbuilder" {
  cidr_block = "10.11.12.0/24"
}

resource "aws_internet_gateway" "tfbuilder" {
  vpc_id = "${aws_vpc.tfbuilder.id}"
}

resource "aws_route_table" "tfbuilder" {
  vpc_id = "${aws_vpc.tfbuilder.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tfbuilder.id}"
  }
}

resource "aws_route_table_association" "tfbuilder" {
  subnet_id      = "${aws_subnet.tfbuilder.id}"
  route_table_id = "${aws_route_table.tfbuilder.id}"
}

resource "aws_subnet" "tfbuilder" {
  vpc_id     = "${aws_vpc.tfbuilder.id}"
  cidr_block = "10.11.12.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "tfbuilder" {
  vpc_id = "${aws_vpc.tfbuilder.id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "tfbuilder" {
  key_name = "tfbuilder"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "tfbuilder" {
  ami                    = "${var.base_ami}"
  instance_type          = "c4.8xlarge"
  key_name               = "${aws_key_pair.tfbuilder.id}"
  subnet_id              = "${aws_subnet.tfbuilder.id}"
  vpc_security_group_ids = ["${aws_security_group.tfbuilder.id}"]

  provisioner "remote-exec" {
    connection {
      user   = "ubuntu"
    }
    script = "${path.module}/tfbuilder-setup.sh"
  }
}

output "ip" { value = "${aws_instance.tfbuilder.public_ip}" }
