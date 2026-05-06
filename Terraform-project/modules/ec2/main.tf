resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "lt" {
  image_id      = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.ec2_sg.id] 

  user_data = base64encode(<<EOF
#!/bin/bash
apt update
apt install -y nginx
systemctl start nginx
echo "Hello from Terraform" > /var/www/html/index.html
EOF
  )
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity    = var.desired_capacity
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
}
