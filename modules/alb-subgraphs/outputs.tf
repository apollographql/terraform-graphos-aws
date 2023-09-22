output "lattice_service_arn" {
  value = module.lattice.lattice_service_arn
}

output "subgraph_url" {
  value = "https://${module.lattice.lattice_service_domain_name}/"
}
