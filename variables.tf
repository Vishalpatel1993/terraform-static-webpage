variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix."
}

#Good practice to tag everything for billing, tracking etc.
variable "tags" {
  description = "tags you want applied to all components."
}
