output "load_balancer_dns" {
  description = "DNS público do Load Balancer"
  value       = aws_lb.web_alb.dns_name
}
