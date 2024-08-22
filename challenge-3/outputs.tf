output "lb_address" {
  value = aws_lb.main.dns_name
}