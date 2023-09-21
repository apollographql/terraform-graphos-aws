output "lattice_service_arn" {
  value = aws_vpclattice_service.this.arn
}

output "lattice_listener_arn" {
  value = aws_vpclattice_listener.this.arn
}
