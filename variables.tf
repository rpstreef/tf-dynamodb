# -----------------------------------------------------------------------------
# Variables: General
# -----------------------------------------------------------------------------

variable "environment" {
  description = "AWS resource environment/prefix"
}

variable "region" {
  description = "AWS region"
}

variable "resource_tag_name" {
  description = "Resource tag name for cost tracking"
}

variable "dynamodb_module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is true."
  default     = true
}

# -----------------------------------------------------------------------------
# Variables: DynamoDB required
# -----------------------------------------------------------------------------

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
}

variable "dynamodb_hash_key" {
  type        = string
  description = "DynamoDB table Hash Key"
}

variable "dynamodb_hash_key_type" {
  type        = string
  default     = "S"
  description = "Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "dynamodb_range_key" {
  type        = string
  default     = ""
  description = "DynamoDB table Range Key"
}

variable "dynamodb_range_key_type" {
  type        = string
  default     = "S"
  description = "Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
}

variable "dynamodb_attributes_map" {
  type = list(object({
    name = string
    type = string
  }))
  default     = []
  description = "Additional DynamoDB attributes in the form of a list of mapped values"
}

variable "dynamodb_global_secondary_index_map" {
  type = list(object({
    hash_key           = string
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
    read_capacity      = number
    write_capacity     = number
  }))
  default     = []
  description = "Additional global secondary indexes in the form of a list of mapped values"
}

variable "dynamodb_local_secondary_index_map" {
  type = list(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
  default     = []
  description = "Additional local secondary indexes in the form of a list of mapped values"
}

# -----------------------------------------------------------------------------
# Variables: DynamoDB optional
# -----------------------------------------------------------------------------
variable "dynamodb_billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}

variable "dynamodb_server_side_encryption" {
  type    = bool
  default = false
}

variable "dynamodb_point_in_time_recovery" {
  type    = bool
  default = false
}

variable "dynamodb_stream_enabled" {
  type        = bool
  description = "Indicates whether Streams are to be enabled (true) or disabled (false)."
  default     = false
}

variable "dynamodb_stream_view_type" {
  type        = string
  description = "When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  default     = null
}
