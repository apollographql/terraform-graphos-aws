output "lattice_service_arn" {
  value = aws_vpclattice_service.this.arn
}

output "lattice_service_domain_name" {
  value = aws_vpclattice_service.this.dns_entry[0].domain_name
}

output "lattice_listener_arn" {
  value = aws_vpclattice_listener.this.arn
}
