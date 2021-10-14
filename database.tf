resource "aws_instance" "mysql" {
  ami           = "ami-0d382e80be7ffdae5"
  instance_type = "t2.micro"
  depends_on = [aws_security_group.sg_mysql]
  key_name = "aws_key"
  user_data = templatefile("./scripts/mysql.sh.tpl", {
    DATASOURCE_USERNAME = var.DATASOURCE_USERNAME
    DATASOURCE_PASSWORD = var.DATASOURCE_PASSWORD
    MYSQL_ROOT_PASSWORD = var.MYSQL_ROOT_PASSWORD
    }
  )
  vpc_security_group_ids = [aws_security_group.sg_mysql.id]
  subnet_id              = aws_subnet.public_subnet.id

  tags = {
    Owner   = "Vadim Tailor"
    Project = "awsEschool"
    Name    = "mysql db"
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "runer" {
  ami           = "ami-0d382e80be7ffdae5"
  instance_type = "t2.micro"
  depends_on = [aws_security_group.app]
  key_name = "aws_key"
  user_data = templatefile("./scripts/runer.sh.tpl", {
    registration_token = var.registration_token
    }
  )
  vpc_security_group_ids = [aws_security_group.sg_mysql.id]
  subnet_id              = aws_subnet.public_subnet.id

  tags = {
    Owner   = "Vadim Tailor"
    Project = "awsEschool"
    Name    = "runner"
  }
  lifecycle {
    create_before_destroy = true
  }
}




# vpc
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name    = "vpc"
    Owner   = "Vadim Tailor"
    Project = "awsEschool"
  }

  enable_dns_hostnames = true
}


# public subnet
resource "aws_subnet" "public_subnet" {
  depends_on = [aws_vpc.vpc]

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_cidr

  # availability_zone_id = "us-west-1b"

  tags = {
    Name    = "public_subnet"
    Owner   = "Vadim Tailor"
    Project = "awsEschool"
  }

  map_public_ip_on_launch = true
}



# internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "internet-gateway"
    Owner   = "Vadim Tailor"
    Project = "awsEschool"
  }
}

# route table with target as internet gateway
resource "aws_route_table" "IG_route_table" {
  depends_on = [
    aws_vpc.vpc,
    aws_internet_gateway.internet_gateway,
  ]

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name    = "IG-route-table"
    Owner   = "Vadim Tailor"
    Project = "awsEschool"
  }
}

# associate route table to public subnet
resource "aws_route_table_association" "associate_routetable_to_public_subnet" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.IG_route_table,
  ]
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.IG_route_table.id
}



# mysql security group
resource "aws_security_group" "sg_mysql" {
  depends_on = [
    aws_vpc.vpc,
  ]
  name        = "sg mysql"
  description = "Allow mysql inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "allow TCP"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




# wordpress security group
resource "aws_security_group" "app" {
  depends_on = [
    aws_vpc.vpc,
  ]

  name        = "sg app"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "allow TCP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
