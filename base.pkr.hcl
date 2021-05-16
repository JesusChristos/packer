

source "digitalocean" "this" {
  api_token = ""
  region = "fra1"
  size = "s-1vcpu-1gb"
  image = "ubuntu-18-04-x64"
  snapshot_name = "node-droplet-base-docker"
  ssh_username = "root"
  ssh_password = ""
  droplet_name = "packer-builder"
}

build {
  sources = ["source.digitalocean.this"]
  provisioner "shell" {
    inline = [
      "echo \"Starting update\"",
      "apt-get update",
      "apt-get install apt-transport-https ca-certificates curl gnupg lsb-release curl wget -y",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "apt-get update",
      "apt-get install docker-ce docker-ce-cli containerd.io -y"
    ]
  }
}