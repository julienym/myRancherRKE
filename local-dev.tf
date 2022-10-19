resource "local_file" "crke_kubeconfig" {
    content  = rancher2_cluster_v2.this.kube_config
    filename = pathexpand("~/.kube/clusters/${local.rke_name}")
}
