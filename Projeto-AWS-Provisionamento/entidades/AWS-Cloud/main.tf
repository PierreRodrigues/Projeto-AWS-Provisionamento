# === Provedor AWS ===
provider "aws" {
  region = "us-east-1"
}

# === VPC ===
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC-HighAvailability"
  }
}

# === Subnets ===
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "Subnet-A" }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "Subnet-B" }
}

# === Internet Gateway ===
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "IGW-HighAvailability" }
}

# === Route Table ===
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = { Name = "RT-Public" }
}

# === Association das subnets ===
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# === Security Groups ===

## Load Balancer (aceita só HTTP)
resource "aws_security_group" "alb_sg" {
  name        = "SG-ALB"
  description = "Permite HTTP público"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "SG-ALB" }
}

## EC2 (recebe só do ALB e SSH do seu IP)
resource "aws_security_group" "ec2_sg" {
  name        = "SG-EC2"
  description = "Permite tráfego apenas do ALB e SSH local"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP do Load Balancer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH do IP local"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_PUBLIC_IP/32"] # <== TROQUE PELO SEU IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "SG-EC2" }
}

# === Launch Template (modelo das instâncias) ===
resource "aws_launch_template" "web_template" {
  name_prefix   = "LT-WebServer"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = filebase64("${path.module}/userdata.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WebServer"
    }
  }
}

# === Pegar a AMI mais recente Amazon Linux 2 ===
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# === Target Group ===
resource "aws_lb_target_group" "web_tg" {
  name     = "TG-Web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/"
  }
}

# === Load Balancer ===
resource "aws_lb" "web_alb" {
  name               = "ALB-Web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = { Name = "ALB-Web" }
}

# === Listener ===
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# === Auto Scaling Group ===
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  target_group_arns    = [aws_lb_target_group.web_tg.arn]
  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "ASG-WebServer"
    propagate_at_launch = true
  }
}

# === Auto Scaling Policy (por CPU) ===
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "ScaleByCPU"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
