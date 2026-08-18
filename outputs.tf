output "master_internal_ip" {
  description = "Internal IP address of Kubernetes master"
  value       = yandex_compute_instance.master.network_interface[0].ip_address
}

output "master_external_ip" {
  description = "External IP address of Kubernetes master"
  value       = yandex_compute_instance.master.network_interface[0].nat_ip_address
}

output "worker_internal_ips" {
  description = "Internal IP addresses of Kubernetes workers"
  value = [
    for worker in yandex_compute_instance.worker :
    worker.network_interface[0].ip_address
  ]
}

output "worker_external_ips" {
  description = "External IP addresses of Kubernetes workers"
  value = [
    for worker in yandex_compute_instance.worker :
    worker.network_interface[0].nat_ip_address
  ]
}
