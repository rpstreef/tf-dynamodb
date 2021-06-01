locals {
  o_dynamodb_table = try(aws_dynamodb_table._[0], {})
}

# -----------------------------------------------------------------------------
# Outputs: Cognito
# -----------------------------------------------------------------------------

output "user_pool" {
  description = "The full `aws_dynamodb_table` object."
  value       = local.o_dynamodb_table
}