# resource "null_resource" "copy_nginx_conf" {
#   count = var.instance_count > 2 ? 2 : var.instance_count

#   provisioner "remote-exec" {
#     inline = [
#       "sudo sh -c 'echo \"server {\\n    listen       80;\\n    listen       [::]:80;\\n    server_name  _;\\n    location / {\\n        proxy_pass http://${var.internal_lb_dns_name}/student/;\\n    }\\n}\" > /etc/nginx/nginx.conf'",
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
