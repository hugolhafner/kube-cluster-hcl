resource "helm_release" "argo-haproxy" {
  name       = "argo-haproxy"

  repository = "https://haproxy-ingress.github.io/charts"
  chart      = "haproxy-ingress"

  values = ["${file("helm/haproxy.values.yaml")}"]

  namespace = "argo"
  create_namespace = true
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
    helm_release.argo-haproxy
  ]
}