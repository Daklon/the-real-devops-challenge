output "lb_address" {
  description = "The load balancer address"
  value       = aws_lb.main.dns_name
}