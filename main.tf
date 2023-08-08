resource "aws_s3_bucket" "example" {
  bucket = "point-loop"

  tags = {
    Name        = "point-loop"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.example.id
  key    = "Main"
  source = "/home/user/Desktop/Main"
  etag = filemd5("/home/user/Desktop/Main")
}


resource "aws_s3_object" "object-2" {
  bucket = aws_s3_bucket.example.id
  key    = "Main.service"
  source = "/etc/systemd/system/Main.service"
  etag = filemd5("/etc/systemd/system/Main.service")
}
 

resource "aws_instance" "project111" {
  ami           = "ami-0f5ee92e2d63afc18" 
  iam_instance_profile = aws_iam_instance_profile.some_profile.name
  instance_type = "t2.micro"
   key_name               = "ka-key"
  security_groups        = [aws_security_group.elb_sg.name]

  associate_public_ip_address = true

    user_data = <<-EOF
#!/bin/bash
       set -x
       sudo apt-get update -y
       sudo apt-get install awscli -y
       sudo apt install awscli
       aws s3 cp s3://point-loop/Main /home/ubuntu
       aws s3 cp s3://point-loop/Main.service    /etc/systemd/system
       cd /home/ubuntu
       chmod +x Main
       cd /etc/systemd/system/
       sudo systemctl enable Main
       sudo systemctl daemon-reload 
       sudo systemctl restart Main
       EOF



}

	
resource "aws_iam_policy" "bucket_policy" {
  name        = "my-name-new1-0"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::point-loop"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "ecssssssss2reuigthsjakebhd-0"

  assume_role_policy = jsonencode({ 

    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "some_bucket_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}


resource "aws_iam_instance_profile" "some_profile" {
  name = "new1afkzbds"
  role = aws_iam_role.ec2_role.name
}





resource "aws_security_group" "elb_sg" {
  name        = "avnnfgjhersgfktrse"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] 
  
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port         = 443 
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
   ingress {
    from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   ingress {
    from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}




