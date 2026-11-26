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
