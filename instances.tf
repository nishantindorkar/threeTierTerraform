resource "aws_instance" "public_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.main-sg.id]
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = var.ecs_associate_public_ip_address
  tags = {
    Name = "jump-server"
  }
}

resource "aws_instance" "private_instances" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.private[count.index % length(aws_subnet.private)].id
  vpc_security_group_ids = [aws_security_group.main-sg.id]

  tags = {
    Name = "private-instance-${var.name_prefix[floor(count.index / 2)]}-${count.index % 2 + 1}"
  }

 user_data = lookup(
    {
      for i in range(var.instance_count):
      i =>
        i == 0 || i == 1 ? <<-EOF
                            #!/bin/bash
                            sudo apt update -y
                            sudo apt install nginx -y
                            sudo systemctl start nginx
                            EOF
        :
        i == 2 || i == 3 ? <<-EOF
                            #!/bin/bash
                            sudo apt update -y
                            #sudo apt install wget -y
                            sudo apt install openjdk-11-jre-headless -y
                            sudo apt update -y
                            sudo wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.87/bin/apache-tomcat-8.5.87.tar.gz
                            sudo tar -xvzf apache-tomcat-8.5.87.tar.gz
                            sudo wget https://s3-us-west-2.amazonaws.com/studentapi-cit/student.war -P apache-tomcat-8.5.87/webapps/
                            sudo wget https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar -P apache-tomcat-8.5.87/lib/
                            sudo sh apache-tomcat-8.5.87/bin/catalina.sh stop
                            sudo sh apache-tomcat-8.5.87/bin/catalina.sh start
                            EOF
        :
        i == 4 ? <<-EOF
                  #!/bin/bash
                  sudo apt update -y
                  sudo apt install mysql-server -y
                  sudo systemctl start mysql
                  sudo systemctl enable mysql
                  EOF
        :
        ""
    },
    count.index,
    ""
  )

  # Prevent user_data script from being copied to instance
  # by excluding it from the metadata options
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
  }
}