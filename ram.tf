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

// Associate the AWS VPC Lattice Service with this resource share
resource "aws_ram_resource_association" "this" {
  resource_arn       = aws_vpclattice_service.this.arn
  resource_share_arn = aws_ram_resource_share.this.arn
}
