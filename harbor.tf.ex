
module "harbor" {
  depends_on = [
    module.longhorn,
    kubernetes_manifest.cluster_issuer
  ]
  source = "../../modules/helm"
  name = "harbor"
  repository = "https://helm.goharbor.io"
  namespace = "harbor"
  chart = "harbor"
  chart_version = "1.8.1"
  values = {
    "expose.tls.certSource" = "secret"
    "expose.tls.secret.secretName" = "harbor-cert"
    "expose.ingress.hosts.core" = "harbor.tools.home"
    "expose.ingress.hosts.notary" = "notary.tools.home"
    "expose.ingress.harbor.annotations.cert-manager\\.io/cluster-issuer" = "tools-ca"
    externalURL = "https://harbor.tools.home"
    "ipFamily.ipv6.enabled" = false
    "persistence.resourcePolicy" = ""
    "persistence.persistentVolumeClaim.registry.size" = "50Gi"
    harborAdminPassword = var.harbor_admin_password
    secretKey = var.harbor_storage_encryption
    # "registry.credentials.password"
    "chartmuseum.enabled" = false
    "trivy.enabled" = true
    "trivy.gitHubToken" = var.github_token
    "trivy.resources.limits.memory" = "2Gi"
    "notary.enabled" = false
    "database.internal.password" = var.harbor_db_passwd
  }
}
