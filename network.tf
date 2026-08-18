resource "yandex_vpc_network" "k8s" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s" {
  name           = "k8s-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.k8s.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
