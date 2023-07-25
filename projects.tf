resource "rancher2_project" "this" {
  depends_on = [
    rancher2_cluster_sync.this,
  ]
  for_each = toset([
    "ipmi",
    "monitoring",
    "tools",
    "security"
  ])

  name = each.key
  cluster_id = rancher2_cluster_v2.this.cluster_v1_id
}

# resource "rancher2_registry" "harbor" {
#   depends_on = [
#     module.harbor
#   ]
#   for_each = toset([
#     "ipmi",
#     "monitoring",
#     "tools"
#   ])

#   name = "harbor"
#   project_id = rancher2_project.this[each.key].id
#   registries {
#     address = "harbor.tools.mgt"
#     username = "admin"
#     password = var.harbor.harbor_admin_password
#   }
# }