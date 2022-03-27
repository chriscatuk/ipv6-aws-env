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
  description = "(Optional) DNS Records to create in that domain for IPv4"
  type = list(object({
    name    = string
    records = list(string)
  }))
  default = []
}


variable "aaaa_records" {
  description = "(Optional) DNS Records to create in that domain for IPv6"
  type = list(object({
    name    = string
    records = list(string)
  }))
  default = []
}

variable "cname_records" {
  description = "(Optional) DNS Records to create in that domain as CNAMES"
  type = list(object({
    name    = string
    records = list(string)
  }))
  default = []
}
