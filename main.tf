#--------------------------------------------------------------#
#Create instance EC2 and security group, install security group#
#--------------------------------------------------------------#


 provider "aws" {

  region = "eu-central-1"

 } 
 
 resource "aws_instance" "webserver" {
    ami = "ami-0767046d1677be5a0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webserver.id] 
                                                                                          #create dependence
    user_data = file("jenkinsInstall.sh") 
    key_name                  =   "aws_key_2"                                                      
   connection  {
    host= self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = file("/home/libo/Course/secret/aws_key_2")
  }

   provisioner "file" {
    source      = "jenkinsInstall.sh"
    destination = "/tmp/jenkinsInstall.sh"
  }

   provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jenkinsInstall.sh",
      "sudo /tmp/jenkinsInstall.sh",
    ]
  }
                                                                                      #bootstraping(automatically starting command)
 }

resource "aws_security_group" "webserver" {
  name        = "webserver security group"
  description = "Security group"
 
  ingress {                      
                                                                                          #in (server)
    from_port   = 80            
                                                                                          #if create new rule, just add same ingress with new param, same to engress
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
   from_port = 8080
   to_port = 8080
   protocol = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  egress {                       
                                                                                          #out (server)
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tcp"
  }
}
