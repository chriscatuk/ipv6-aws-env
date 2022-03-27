variable "route53_zoneid" {
  description = "DNS Route 53 zone ID"
  type        = string
}

variable "ttl" {
  description = "(optional) TTL of the record in seconds. Default: 60"
  type        = number
  default     = 60
}

variable "a_records" {
  description = "DNS Record to create in that domain"
  type = list(object({
    name    = string
    records = list(string)
  }))
  default = null
}
