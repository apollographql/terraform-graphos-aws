resource "aws_ram_resource_share" "this" {
  name                      = "${var.prefix}-subgraphs"
  allow_external_principals = true

  tags = var.tags
}

// Send an association invitation to Apollo GraphOS
resource "aws_ram_principal_association" "this" {
  principal          = var.graphos_account_id
  resource_share_arn = aws_ram_resource_share.this.arn
}

// Associate the AWS VPC Lattice Services with this resource share
resource "aws_ram_resource_association" "alb_subgraphs" {
  for_each = var.alb_subgraphs

  resource_arn       = module.alb_subgraphs[each.key].lattice_service_arn
  resource_share_arn = aws_ram_resource_share.this.arn
}

resource "aws_ram_resource_association" "lambda_subgraphs" {
  count = length(var.lambda_subgraphs) > 0 ? 1 : 0

  resource_arn       = module.lambda_subgraphs[0].lattice_service_arn
  resource_share_arn = aws_ram_resource_share.this.arn
}
