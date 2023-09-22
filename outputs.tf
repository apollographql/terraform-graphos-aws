output "resource_share_arn" {
  value = aws_ram_resource_share.this.arn
}

output "alb_subgraph_urls" {
  value = {
    for name, value in var.alb_subgraphs :
    name => module.alb_subgraphs[name].subgraph_url
  }
}

output "lambda_subgraph_urls" {
  value = length(var.lambda_subgraphs) > 0 ? module.lambda_subgraphs[0].subgraph_urls : {}
}
