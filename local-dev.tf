resource "local_file" "crke_kubeconfig" {
  content  = rancher2_cluster_v2.this.kube_config
  filename = pathexpand("~/.kube/clusters/${var.rke.cluster_name}")
}
