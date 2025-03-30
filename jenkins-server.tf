#*****************FETCHING LATEST AMI ID OF UBUNTU ********************#

data "aws_ami" "latest_ubuntu" {     # aws_ami helps to get AMI ID of the os
    most_recent = true  # this is the filter for most recent Ami
   
    filter {   # this is the filter for virtualization type
      name = "virtualization-type"
      values = ["hvm"]
    }
    filter {  # this is the filter for AMI name of the OS which can be found in AMI section in EC2
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
     owners = ["099720109477"]  # this is the owner of the OS, which can be found in AMI section in EC2
}

#*****************Creating EC2 instance out of this latest ami********************#

resource "aws_instance" "jenkins-server" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.medium"
  subnet_id = aws_subnet.nike-public-subnet1.id
  key_name = "Key"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  security_groups = [aws_security_group.nike-security-group-main.id]
  user_data = file("./jenkins-server.sh")
  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "Jenkins-server"
  }
}