#create EC2-webserver
resource "aws_instance" "lms-web-server" {
  availability_zone = "us-west-2a"
  ami           = "ami-0606dd43116f5ed57" 
  instance_type = "t2.micro"
  subnet_id = aws_subnet.Lms-web-sn.id
  key_name = "MahaKey"
  vpc_security_group_ids = [aws_security_group.lms-web-sg.id]
  user_data = file("setup.sh")
  tags ={ 
    Name= "lms-web_server"
  }
}