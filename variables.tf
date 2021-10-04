variable "create_bucket" {
  description = "create the example buckets"
  type        = bool
  default     = false
}

variable "bucket_a" {
  description = "Name of bucket a" 
  type        = string
  default     = ""
}

variable "bucket_b" {
  description = "Name of bucket a" 
  type        = string
  default     = ""
}

variable "user_a" {
  description = "Name of user a"
  type        = string
  default     = ""
}

variable "user_b" {
  description = "Name of user b"
  type        = string
  default     = ""
}
