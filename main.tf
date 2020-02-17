data "aws_caller_identity" "_" {}

locals {
  table_name           = "${local.resource_name_prefix}-${var.dynamodb_table_name}"
  resource_name_prefix = "${var.namespace}-${var.resource_tag_name}"
  table_arn = "arn:aws:dynamodb:${
    var.region
    }:${
    data.aws_caller_identity._.account_id
    }:table/${
    local.table_name
  }"
}

resource "null_resource" "global_secondary_index_names" {
  count = length(var.global_secondary_index_map)

  triggers = {
    "name" = var.global_secondary_index_map[count.index]["name"]
  }
}

resource "null_resource" "local_secondary_index_names" {
  count = length(var.local_secondary_index_map)

  triggers = {
    "name" = var.local_secondary_index_map[count.index]["name"]
  }
}

resource "aws_dynamodb_table" "_" {
  name         = local.table_name
  billing_mode = var.billing_mode
  hash_key     = var.hash_key
  range_key    = var.range_key

  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type

  server_side_encryption {
    enabled = var.server_side_encryption
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index_map

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
    for_each = var.local_secondary_index_map
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

  tags = {
    Name        = var.resource_tag_name
    Environment = var.namespace
  }
}
