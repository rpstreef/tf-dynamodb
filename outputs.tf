output "name" {
  value       = local.table_name
  description = "DynamoDB table name"
}

output "id" {
  value       = aws_dynamodb_table._.id
  description = "DynamoDB table ID"
}

output "arn" {
  value       = local.table_arn
  description = "DynamoDB table ARN"
}

output "global_secondary_index_names" {
  value       = null_resource.global_secondary_index_names.*.triggers.name
  description = "DynamoDB secondary index names"
}

output "local_secondary_index_names" {
  value       = null_resource.local_secondary_index_names.*.triggers.name
  description = "DynamoDB local index names"
}

output "stream_arn" {
  value       = aws_dynamodb_table._.stream_arn
  description = "The ARN of the Table Stream. Only available when stream_enabled = true"
}

output "stream_label" {
  value = aws_dynamodb_table._.stream_label
  description = "A timestamp, in ISO 8601 format, for this stream. Note that this timestamp is not a unique identifier for the stream on its own. However, the combination of AWS customer ID, table name and this field is guaranteed to be unique. It can be used for creating CloudWatch Alarms. Only available when stream_enabled = true"
}