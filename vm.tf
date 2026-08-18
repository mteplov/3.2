data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

locals {
  ssh_key = trimspace(file(pathexpand("~/.ssh/id_github_no_pass.pub")))

  cloud_init = <<-EOF
    #cloud-config

    users:
      - name: ubuntu
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        lock_passwd: true
        ssh_authorized_keys:
          - ${local.ssh_key}

    packages:
      - openssh-server

    runcmd:
      - systemctl enable ssh
      - systemctl restart ssh
      - ufw disable

    ssh_pwauth: false
  EOF
}

resource "yandex_compute_instance" "master" {
  name = "k8s-master"
  zone = var.zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.k8s.id
    ip_address         = "192.168.10.10"
    nat                = true
    security_group_ids = [yandex_vpc_security_group.k8s.id]
  }

  metadata = {
    user-data          = local.cloud_init
    serial-port-enable = "1"
  }
}

resource "yandex_compute_instance" "worker" {
  count = 4

  name = "k8s-worker-${count.index + 1}"
  zone = var.zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 30
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.k8s.id
    ip_address         = "192.168.10.${11 + count.index}"
    nat                = true
    security_group_ids = [yandex_vpc_security_group.k8s.id]
  }

  metadata = {
    user-data          = local.cloud_init
    serial-port-enable = "1"
  }
}
