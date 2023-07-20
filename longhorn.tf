module "longhorn" {
  depends_on = [
    rancher2_cluster_sync.this,
  ]
  source = "git::https://github.com/julienym/myTerraformModules.git//helm?ref=main"

  name          = "longhorn"
  repository    = "https://charts.longhorn.io"
  namespace     = "longhorn-system"
  chart         = "longhorn"
  chart_version = "1.4.2" #https://github.com/longhorn/charts/releases
  values = {              #Default values here: https://github.com/longhorn/charts/blob/master/charts/longhorn/values.yaml
    "defaultSettings.defaultDataPath"          = "/mnt/longhorn-ssd"
    "defaultSettings.defaultReplicaCount"      = 1
    "csi.attacherReplicaCount"                 = 1
    "csi.provisionerReplicaCount"              = 1
    "csi.resizerReplicaCount"                  = 1
    "csi.snapshotterReplicaCount"              = 1
    "longhornUI.replicas"                      = 1
    "longhornConversionWebhook.replicas"       = 1
    "longhornAdmissionWebhook.replicas"        = 1
    "longhornRecoveryBackend.replicas"         = 1
    "persistence.defaultClassReplicaCount"     = 1
    "defaultSettings.deletingConfirmationFlag" = 0
  }
}
