# Terraform AWS DynamoDB module

## About:

AWS DynamoDB Terraform module that supports dynamic GSI's, LSI's, and table attributes.

Please note the ignore changes set by default to prevent change deployments to AWS, remove when needed:

```terraform
lifecycle {
  ignore_changes = [
    read_capacity,
    write_capacity,
    global_secondary_index,
    local_secondary_index
  ]
}
```

## How to use:

```terraform
module "dynamodb" {
  source = "github.com/rpstreef/tf-dynamodb?ref=v1.0"

  resource_tag_name = var.resource_tag_name
  namespace         = var.namespace
  region            = var.region

  dynamodb_table_name = var.dynamodb_table_name
  hash_key            = var.dynamodb_hash_key
  range_key           = var.dynamodb_range_key

  attributes = [
    {
      name = var.dynamodb_hash_key
      type = "S"
    },
    {
      name = var.dynamodb_range_key
      type = "S"
    }
  ]

  global_secondary_index_map = [
    {
      name               = var.dynamodb_gsi_1_name
      hash_key           = var.dynamodb_gsi_1_hash_key
      range_key          = var.dynamodb_gsi_1_range_key
      projection_type    = var.dynamodb_gsi_1_projection_type
      write_capacity     = var.dynamodb_gsi_1_write_capacity
      read_capacity      = var.dynamodb_gsi_1_read_capacity
      non_key_attributes = null
    }
  ]
}
```

## Changelog

### v1.1
- Added module on/off switch ``dynamodb_module_enabled``
- Added full dynamodb output object

### v1.0

Initial release