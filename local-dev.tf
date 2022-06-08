resource "local_file" "crke_kubeconfig" {
    content  = rancher2_cluster.this.kube_config
    filename = pathexpand("~/.kube/clusters/${local.rke_name}")
}
