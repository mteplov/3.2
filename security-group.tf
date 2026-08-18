resource "yandex_vpc_security_group" "k8s" {
  name       = "k8s-security-group"
  network_id = yandex_vpc_network.k8s.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "Kubernetes API"
    v4_cidr_blocks = ["192.168.10.0/24"]
    port           = 6443
  }

  ingress {
    protocol       = "TCP"
    description    = "Kubelet API"
    v4_cidr_blocks = ["192.168.10.0/24"]
    port           = 10250
  }

  ingress {
    protocol       = "TCP"
    description    = "etcd client"
    v4_cidr_blocks = ["192.168.10.0/24"]
    port           = 2379
  }

  ingress {
    protocol       = "TCP"
    description    = "etcd peer"
    v4_cidr_blocks = ["192.168.10.0/24"]
    port           = 2380
  }

  ingress {
    protocol       = "TCP"
    description    = "Kube scheduler"
    v4_cidr_blocks = ["192.168.10.0/24"]
    port           = 10259
  }

  ingress {
    protocol       = "TCP"
    description    = "Kube controller manager"
    v4_cidr_blocks = ["192.168.10.0/24"]
    port           = 10257
  }

  ingress {
    protocol       = "TCP"
    description    = "NodePort TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }

  ingress {
    protocol       = "UDP"
    description    = "NodePort UDP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }

  ingress {
    protocol       = "ICMP"
    description    = "ICMP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
