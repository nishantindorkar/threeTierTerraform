output "lb_dns_name" {
  value = aws_lb.nginx_lb.dns_name
}

output "internal_lb_dns_name" {
  value = aws_lb.internal_alb.dns_name
}