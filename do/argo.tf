resource "helm_release" "nginx-argo" {
  name       = "nginx-argo"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = ["${file("helm/nginx.argo.values.yaml")}"]

  namespace = "argo"

  depends_on = [
    kubernetes_namespace.argo
  ]
}

resource "kubernetes_secret" "tunnel-credentials" {
  metadata {
    name = "tunnel-credentials"
    namespace = "argo"
  }

  data = {
    "credentials.json": "${file("argo-creds.json")}"
  }

  depends_on = [
    kubernetes_namespace.argo
  ]
}