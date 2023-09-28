// Check that the Lambda function ARNs exist
data "aws_lambda_function" "subgraph" {
  for_each      = var.lambda_function_arns
  function_name = each.value
}
