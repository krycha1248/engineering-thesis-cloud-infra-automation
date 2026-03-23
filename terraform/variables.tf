variable "cloudflare_zone_id" {
  sensitive = true
  type      = string
}

variable "domain_name" {
  sensitive = false
  type      = string
  default   = "shiplify.pl"
}
