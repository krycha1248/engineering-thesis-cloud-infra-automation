resource "cloudflare_dns_record" "recordA" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  type    = "A"
  content = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "recordCNAME" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  type    = "CNAME"
  content = cloudflare_dns_record.recordA.name
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "connection" {
  zone_id = var.cloudflare_zone_id
  name    = "vps"
  type    = "CNAME"
  content = cloudflare_dns_record.recordA.name
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

resource "ansible_playbook" "astro" {
  name       = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
  playbook   = "${path.module}/../ansible/deploy.yml"
  replayable = true
  extra_vars = {
    domain_name                  = var.domain_name
    become                       = true
    ansible_user                 = "debian"
    ansible_ssh_private_key_file = "~/ssh_klucz"
    ansible_port                 = 22
    username                     = "krystian"
    password                     = "testowehaslo123"
  }
}

output "ansible_stdout" {
  value = ansible_playbook.astro.ansible_playbook_stdout
}
