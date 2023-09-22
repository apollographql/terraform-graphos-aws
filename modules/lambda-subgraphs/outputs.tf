output "lattice_service_arn" {
  value = module.lattice.lattice_service_arn
}

output "subgraph_urls" {
  value = {
    for name, arn in var.lambda_function_arns :
    name => "https://${module.lattice.lattice_service_domain_name}/${name}/"
  }
}
