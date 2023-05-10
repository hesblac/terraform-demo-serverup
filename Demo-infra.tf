
provider "aws" {
profile = "myaws"
region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "hes-vpc"
  }
}

# Create subnets in two availability zones
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

# Create internet gateway and attach to VPC
resource "aws_internet_gateway" "hesgw" {
  vpc_id = aws_vpc.main.id
}

# Create route table and associate with subnets
resource "aws_route_table" "hesrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hesgw.id
  }
}

resource "aws_route_table_association" "subnet1" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.hesrt.id
}

resource "aws_route_table_association" "subnet2" {
  subnet_id = aws_subnet.subnet2.id
  route_table_id = aws_route_table.hesrt.id
}

# Create security group for Jenkins instance
resource "aws_security_group" "jenkins_sg" {
  name = "jenkins-sg"
  description = "Security group for Jenkins instance"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for Minikube instance
resource "aws_security_group" "minikube_sg" {
  name = "minikube-sg"
  description = "Security group for Minikube instance"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8443
    to_port = 8443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8444
    to_port = 8444
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Jenkins instance in subnet1
resource "aws_instance" "jenkins" {
  ami = "ami-0aa2b7722dc1b5612" # Ubuntu 18.04 LTS
  instance_type = "t2.medium"
  subnet_id = aws_subnet.subnet1.id
  associate_public_ip_address = true
  key_name = "checkup"
  security_groups = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "jenkins-server"
  }
}


# Create Minikube instance in subnet2
resource "aws_instance" "minikube" {
  ami = "ami-0aa2b7722dc1b5612" # Ubuntu 18.04 LTS
  instance_type = "t2.medium"
  subnet_id = aws_subnet.subnet2.id
  associate_public_ip_address = true
  key_name = "checkup"
  security_groups = [aws_security_group.minikube_sg.id]

  tags = {
    Name = "minikube-server"
  }
 }

# Output the public IPs of the instances
output "jenkins_ip" {
  value = aws_instance.jenkins.public_ip
}

output "minikube_ip" {
  value = aws_instance.minikube.public_ip
}


