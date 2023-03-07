# resource "null_resource" "copy_nginx_conf" {
#   count = var.instance_count > 2 ? 2 : var.instance_count

#   provisioner "remote-exec" {
#     inline = [
#       "sudo sh -c 'echo \"server {\\n    listen       80;\\n    listen       [::]:80;\\n    server_name  _;\\n    location / {\\n        proxy_pass http://internal-tomcatlb-11803762.us-east-1.elb.amazonaws.com/student/;\\n    }\\n}\" > /etc/nginx/nginx.conf'",
#       "sudo service nginx restart",
#     ]

#     connection {
#       type        = "ssh"
#       host        = aws_instance.private_instances[count.index].public_ip
#       user        = var.instance_user
#       private_key = file(var.key_name)
#     }
#   }
# }



######## paste database in last instance sample code #########

# resource "aws_instance" "private_instances" {
#   count                  = var.instance_count
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = var.instance_type
#   key_name               = var.key_name
#   subnet_id              = aws_subnet.private[count.index % length(aws_subnet.private)].id
#   vpc_security_group_ids = [aws_security_group.main-sg.id]

#   tags = {
#     Name = "private-instance-${var.name_prefix[floor(count.index / 2)]}-${count.index % 2 + 1}"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo mysql -e 'CREATE DATABASE IF NOT EXISTS studentapp;'",
#       "sudo mysql studentapp -e 'CREATE TABLE IF NOT EXISTS students (",
#       "  student_id INT NOT NULL AUTO_INCREMENT,",
#       "  student_name VARCHAR(100) NOT NULL,",
#       "  student_addr VARCHAR(100) NOT NULL,",
#       "  student_age VARCHAR(3) NOT NULL,",
#       "  student_qual VARCHAR(20) NOT NULL,",
#       "  student_percent VARCHAR(10) NOT NULL,",
#       "  student_year_passed VARCHAR(10) NOT NULL,",
#       "  PRIMARY KEY (student_id)",
#       ");'"
#     ]

#     connection {
#       type        = "ssh"
#       user        = var.instance_user
#       private_key = file(var.key_name)
#       host        = self.public_ip
#     }

#     # Only execute the database setup commands on the last instance created
#     when = count.index == var.instance_count - 1
#   }
# }
