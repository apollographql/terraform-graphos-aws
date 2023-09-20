output "lattice_target_groups" {
  description = "Lattice target groups for each Lambda subgraph"
  value = {
    for name, arn in var.var.lambda_function_arns : name => {
      arn = aws_vpclattice_target_group.this[name].arn
      id  = aws_vpclattice_target_group.this[name].id
    }
  }
}
