resource "cloudflare_dns_record" "appRecordA" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  type    = "A"
  content = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "appRecordCNAME" {
  zone_id = var.cloudflare_zone_id
  name    = "www.${cloudflare_dns_record.appRecordA.name}"
  type    = "CNAME"
  content = cloudflare_dns_record.appRecordA.name
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "pmaRecordA" {
  zone_id = var.cloudflare_zone_id
  name    = var.pma_domain_name
  type    = "A"
  content = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "pmaRecordCNAME" {
  zone_id = var.cloudflare_zone_id
  name    = "www.${cloudflare_dns_record.pmaRecordA.name}"
  type    = "CNAME"
  content = cloudflare_dns_record.pmaRecordA.name
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "ftpRecordA" {
  zone_id = var.cloudflare_zone_id
  name    = var.ftp_domain_name
  type    = "A"
  content = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "connection" {
  zone_id = var.cloudflare_zone_id
  name    = "vps"
  type    = "A"
  content = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
  ttl     = 1
  proxied = false
}