module "cert-manager" {
  source = "../../modules/helm"
  name = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace = "cert-manager"
  chart = "cert-manager"
  chart_version = "v1.7.1"
  values = {
    installCRDs = true
  }
}

resource "kubectl_manifest" "ca_certificate" {
  depends_on = [
    module.cert-manager
  ]
    yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: ca-key-pair
  namespace: cert-manager
data:
  tls.crt: ${base64encode(file("../../${var.ca_cert_path}"))}
  tls.key:  ${base64encode(file("../../${var.ca_key_path}"))}
YAML
}

resource "kubectl_manifest" "ca_issuer" {
  depends_on = [
    module.cert-manager,
    kubectl_manifest.ca_certificate
  ]
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ca-issuer
spec:
  ca:
    secretName: ca-key-pair
YAML
}