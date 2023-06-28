provider "aws" {
  region = "ap-south-1"
  profile = "default"
}

//creating instance

resource "aws_instance" "ec2" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    key_name = "docker1"
   // security_groups = ["rtp03-sg"]
   vpc_security_group_ids = ["${aws_security_group.demo-sg.id}"]
   subnet_id = "${aws_subnet.first-subnet.id}"
}
resource "aws_instance" "ec2-1" {
    ami = "ami-08e5424edfe926b43"
    instance_type = "t2.micro"
    key_name = "docker1"
   // security_groups = ["rtp03-sg"]
   vpc_security_group_ids = ["${aws_security_group.demo-sg.id}"]
   subnet_id = "${aws_subnet.second-subnet.id}"
}

resource "aws_security_group" "demo-sg" {
    name = "demo-sg"
    vpc_id = "${aws_vpc.vpc1.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ssh-sg"

    }

}

//creating a VPC
resource "aws_vpc" "vpc1" {
    cidr_block = "10.1.0.0/16"
    tags = {
      Name = "vpc1"
    }
  
}

// Creating a Subnet 
resource "aws_subnet" "first-subnet" {
    vpc_id = "${aws_vpc.vpc1.id}"
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "first-subnet"
    }
  
}
resource "aws_subnet" "second-subnet" {
    vpc_id = "${aws_vpc.vpc1.id}"
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"
    tags = {
      Name = "second-subnet"
    }

}
resource "aws_subnet" "third-subnet" {
    vpc_id = "${aws_vpc.vpc1.id}"
    cidr_block = "10.1.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1c"
    tags = {
      Name = "third-subnet"
    }

}

//Creating a Internet Gateway 
resource "aws_internet_gateway" "rtp03-igw" {
    vpc_id = "${aws_vpc.vpc1.id}"
    tags = {
      Name = "rtp03-igw"
    }
}

// Create a route table 
resource "aws_route_table" "rtp03-public-rt" {
    vpc_id = "${aws_vpc.vpc1.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.rtp03-igw.id}"
    }
    tags = {
      Name = "rtp03-public-rt"
    }
}

// Associate subnet with routetable 

resource "aws_route_table_association" "first-subnet" {
    subnet_id = "${aws_subnet.first-subnet.id}"
    route_table_id = "${aws_route_table.rtp03-public-rt.id}"
  
}

resource "aws_route_table_association" "second-subnet" {
    subnet_id = "${aws_subnet.second-subnet.id}"
    route_table_id = "${aws_route_table.rtp03-public-rt.id}"

}
resource "aws_route_table_association" "third-subnet" {
    subnet_id = "${aws_subnet.third-subnet.id}"
    route_table_id = "${aws_route_table.rtp03-public-rt.id}"

}




