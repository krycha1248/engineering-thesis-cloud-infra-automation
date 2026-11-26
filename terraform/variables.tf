variable "cloudflare_zone_id" {
  sensitive = true
  type      = string
}

variable "domain_name" {
  sensitive = false
  type      = string
  default   = "app.wlodek.net"
}

variable "pma_domain_name" {
  sensitive = false
  type      = string
  default   = "pma.wlodek.net"
}

variable "ftp_domain_name" {
  sensitive = false
  type      = string
  default   = "files.wlodek.net"
}
