output "lb_dns_name" {
  value = aws_lb.nginx_lb.dns_name
}

output "internal_lb_dns_name" {
  value = aws_lb.internal_alb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}