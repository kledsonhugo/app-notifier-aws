output "lb_fqdn" {
  value       = module.compute.lb_fqdn
  description = "FQDN público do Load Balancer"
}