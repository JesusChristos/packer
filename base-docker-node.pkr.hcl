variable "do_token" {
  type              = string
  default           = "dummy_token"
  sensitive         = true
}

variable "ssh_user" {
  type              = string
  default           = "root"
}
variable "image_version" {
  type              = string
  default           = "node-droplet-base-docker-{{timestamp}}"
}
variable "vm_config" {
  type = map(string)
  default = {
    vm_size         = "s-1vcpu-1gb"
    snapshot_region = "fra1"
    droplet_name    = "image-builder"
    image_os        = "ubuntu-18-04-x64"
  }
}

source "digitalocean" "this" {
  api_token         = var.do_token
  region            = var.vm_config.snapshot_region
  size              = var.vm_config.vm_size
  image             = var.vm_config.image_os
  snapshot_name     = var.image_version
  ssh_username      = var.ssh_user
  droplet_name      = var.vm_config.droplet_name
}

build {
  sources = ["source.digitalocean.this"]
  provisioner "ansible" {
    playbook_file = "../ansible/docker-swarm-provision.yml"
    roles_path = "../ansible/roles"
    ansible_env_vars = [ "ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_SSH_ARGS='-o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s'", "ANSIBLE_NOCOLOR=True" ]
    extra_arguments = [
      "--tags", "provision",
    ]
  }
}