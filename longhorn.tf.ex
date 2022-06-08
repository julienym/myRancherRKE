
module "longhorn" {
  depends_on = [
    module.rancher
  ]
  source = "../../modules/helm"
  name = "longhorn"
  repository = "https://charts.longhorn.io"
  namespace = "longhorn-system"
  chart = "longhorn"
  chart_version = "1.2.3"
  values = {
    "defaultSettings.defaultDataPath" = "/mnt/longhorn"
    "defaultSettings.defaultReplicaCount" = 1
    "csi.attacherReplicaCount" = 1
    "csi.provisionerReplicaCount" = 1
    "csi.resizerReplicaCount" = 1
    "csi.snapshotterReplicaCount" = 1
  }
}
