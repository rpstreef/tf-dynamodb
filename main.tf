data "aws_caller_identity" "_" {}

locals {
  table_name           = "${local.resource_name_prefix}-${var.dynamodb_table_name}"
  resource_name_prefix = "${var.environment}-${var.resource_tag_name}"

  table_arn = "arn:aws:dynamodb:${
    var.region
    }:${
    data.aws_caller_identity._.account_id
    }:table/${
    local.table_name
  }"

  tags = {
    Name        = var.resource_tag_name
    Environment = var.environment
  }
}

resource "null_resource" "global_secondary_index_names" {
  count = length(var.dynamodb_global_secondary_index_map)

  triggers = {
    "name" = var.dynamodb_global_secondary_index_map[count.index]["name"]
  }
}

resource "null_resource" "local_secondary_index_names" {
  count = length(var.dynamodb_local_secondary_index_map)

  triggers = {
    "name" = var.dynamodb_local_secondary_index_map[count.index]["name"]
  }
}

resource "aws_dynamodb_table" "_" {
  count = var.dynamodb_module_enabled ? 1 : 0

  name         = local.table_name
  billing_mode = var.dynamodb_billing_mode
  hash_key     = var.dynamodb_hash_key
  range_key    = var.dynamodb_range_key

  stream_enabled   = var.dynamodb_stream_enabled
  stream_view_type = var.dynamodb_stream_view_type

  server_side_encryption {
    enabled = var.dynamodb_server_side_encryption
  }

  point_in_time_recovery {
    enabled = var.dynamodb_point_in_time_recovery
  }

  dynamic "attribute" {
    for_each = var.dynamodb_attributes_map

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.dynamodb_global_secondary_index_map

    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.value.name
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.dynamodb_local_secondary_index_map
    content {
      name               = local_secondary_index.value.name
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
      global_secondary_index,
      local_secondary_index
    ]
  }

  tags = local.tags
}
