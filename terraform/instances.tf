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

resource "cloudflare_dns_record" "connection" {
  zone_id = var.cloudflare_zone_id
  name    = "vps"
  type    = "A"
  content = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
  ttl     = 1
  proxied = false
}

resource "openstack_compute_instance_v2" "instance" {
  flavor_name = "d2-2"
  key_pair    = "ssh"
  image_name  = "Debian 13"
  name        = "Astro deploy"
  network {
    name = "Ext-Net"
  }
}

resource "ansible_playbook" "playbook" {
  name       = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
  playbook   = "${path.module}/../ansible/deploy.yml"
  replayable = true
  extra_vars = {
    app_domain_name              = cloudflare_dns_record.appRecordA.name
    pma_domain_name              = cloudflare_dns_record.pmaRecordA.name
    become                       = true
    ansible_user                 = "debian"
    ansible_ssh_private_key_file = "~/ssh_klucz"
    ansible_port                 = 22
    username                     = "krystian"
    password                     = "testowehaslo123"
  }
}

output "ansible_stdout" {
  value = ansible_playbook.playbook.ansible_playbook_stdout
}
