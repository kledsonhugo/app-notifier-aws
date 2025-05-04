output "lb_fqdn" {
  value       = "http://${aws_lb.ec2_lb.dns_name}"
  description = "FQDN público do Load Balancer"
}