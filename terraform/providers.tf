terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.11"
    }
    ansible = {
      version = "~> 1.3.0"
      source  = "ansible/ansible"
    }
  }
}

provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/"
  domain_name = "default"
}