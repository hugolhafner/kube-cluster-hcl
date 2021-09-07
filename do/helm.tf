provider "helm" {
  kubernetes {
    host             = digitalocean_kubernetes_cluster.cluster.endpoint
    token            = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
  }
}

resource "helm_release" "velero" {
  count = 0 // TODO: Get this to work properly
  name       = "velero"

  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"

  namespace = "velero"
  create_namespace = true

  set {
    name = "credentials.secretContents.cloud"
    value = <<EOT
[default]
aws_access_key_id=${var.velero.key}
aws_secret_access_key=${var.velero.secret}
EOT
  }

  set {
    name = "credentials.extraEnvVars.DIGITALOCEAN_TOKEN"
    value = var.do_token
  }

  set {
    name = "credentials.backupStorageLocation.bucket"
    value = var.velero.bucket
  }

  values = ["${file("helm/velero.values.yaml")}"]
}

resource "helm_release" "kruise" {
  name       = "kruise"

  chart      = "https://github.com/openkruise/kruise/releases/download/v0.9.0/kruise-chart.tgz"

  namespace = "kruise"
  create_namespace = true
}

resource "helm_release" "chaoskube" {
  name       = "chaoskube"

  repository = "https://linki.github.io/chaoskube"
  chart      = "chaoskube"

  namespace = "chaoskube"
  create_namespace = true

  set {
    name = "image.tag"
    value = "latest"
  }

  set {
    name = "image.pullPolicy"
    value = "Always"
  }

  values = ["${file("helm/chaoskube.values.yaml")}"]
}

resource "helm_release" "litmus" {
  name       = "litmus"

  repository = "https://litmuschaos.github.io/litmus-helm/"
  chart      = "litmus"

  namespace = "litmus"
  create_namespace = true
}

// TODO: Istio configuration for ingress and communication within service mesh
resource "helm_release" "nginx" {
  name       = "nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace = "nginx"
  create_namespace = true

  values = ["${file("helm/nginx.values.yaml")}"]
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  namespace = "cert-manager"
  create_namespace = true

  set {
    name = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "descheduler" {
  name       = "descheduler"

  repository = "https://kubernetes-sigs.github.io/descheduler/"
  chart      = "descheduler"

  namespace = "kube-system"
}

resource "helm_release" "kubefledged" {
  name       = "kubefledged"

  repository = "https://senthilrch.github.io/kubefledged-charts/"
  chart      = "kube-fledged"

  create_namespace = true
  namespace = "kube-fledged"
}

resource "helm_release" "kubernetes-dashboard" {
  name       = "kubernetes-dashboard"

  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"

  create_namespace = true
  namespace = "kubernetes-dashboard"

  values = ["${file("helm/kubernetes-dashboard.values.yaml")}"]
}

resource "helm_release" "vpa" {
  name       = "vpa"

  repository = "https://charts.fairwinds.com/stable"
  chart      = "vpa"

  namespace = "vpa"
  create_namespace = true
}

resource "helm_release" "goldilocks" {
  name       = "goldilocks"

  repository = "https://charts.fairwinds.com/stable"
  chart      = "goldilocks"

  namespace = "goldilocks"
  create_namespace = true
}

resource "helm_release" "metrics-server" {
  name       = "metrics-server"

  repository = "https://charts.helm.sh/stable"
  chart      = "metrics-server"

  namespace = "kube-system"

  values = ["${file("helm/metrics-server.values.yaml")}"]
}

resource "helm_release" "rbac-manager" {
  name       = "rbac-manager"

  repository = "https://charts.fairwinds.com/stable"
  chart      = "rbac-manager"

  namespace = "rbac-manager"
  create_namespace = true
}

resource "helm_release" "kyverno-crds" {
  name       = "kyverno-crds"

  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno-crds"

  namespace = "kyverno"
  create_namespace = true
}

resource "helm_release" "kyverno" {
  name       = "kyverno"

  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"

  namespace = "kyverno"
  create_namespace = true

  depends_on = [
    helm_release.kyverno-crds
  ]
}

resource "helm_release" "kube-state-metrics" {
  count = var.datadog.enabled ? 0 : 1

  name       = "kube-state-metrics"

  repository = "https://charts.helm.sh/stable"
  chart      = "kube-state-metrics"

  namespace = "kube-system"
}

resource "helm_release" "datadog" {
  count = var.datadog.enabled ? 1 : 0

  name       = "datadog"

  repository = "https://charts.fairwinds.com/stable"
  chart      = "datadog"

  values = ["${file("helm/datadog.values.yaml")}"]

  set {
    name = "datadog.apiKey"
    value = var.datadog.api_key
  }

  set {
    name = "datadog.clusterName"
    value = digitalocean_kubernetes_cluster.cluster.name
  }

  namespace = "datadog"

  depends_on = [
    kubernetes_priority_class.cluster-monitor,
    kubernetes_namespace.datadog
  ]
}