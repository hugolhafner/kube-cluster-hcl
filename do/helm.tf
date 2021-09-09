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
  depends_on = [kubernetes_namespace.velero]

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
  depends_on = [kubernetes_namespace.kruise]
}

resource "helm_release" "chaoskube" {
  name       = "chaoskube"

  repository = "https://linki.github.io/chaoskube"
  chart      = "chaoskube"

  namespace = "chaoskube"
  depends_on = [kubernetes_namespace.chaoskube]

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

// TODO: Istio configuration for ingress and communication within service mesh
resource "helm_release" "nginx-staging" {
  name       = "nginx-staging"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace = "nginx-staging"
  depends_on = [kubernetes_namespace.nginx-staging]

  values = ["${file("helm/nginx.staging.values.yaml")}"]

  set {
    name = "controller.service.annotations.service.beta.kubernetes.io/do-loadbalancer-name"
    value = "nginx-${digitalocean_kubernetes_cluster.cluster.name}-staging-lb"
  }
}

resource "helm_release" "nginx-canary" {
  name       = "nginx-canary"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace = "nginx-canary"
  depends_on = [kubernetes_namespace.nginx-canary]

  values = ["${file("helm/nginx.canary.values.yaml")}"]

  set {
    name = "controller.service.annotations.service.beta.kubernetes.io/do-loadbalancer-name"
    value = "nginx-${digitalocean_kubernetes_cluster.cluster.name}-canary-lb"
  }
}

resource "helm_release" "nginx-production" {
  name       = "nginx-production"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  namespace = "nginx-production"
  depends_on = [kubernetes_namespace.nginx-production]

  values = ["${file("helm/nginx.production.values.yaml")}"]

  set {
    name = "controller.service.annotations.service.beta.kubernetes.io/do-loadbalancer-name"
    value = "nginx-${digitalocean_kubernetes_cluster.cluster.name}-production-lb"
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  namespace = "cert-manager"
  depends_on = [kubernetes_namespace.cert-manager]

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

  namespace = "kube-fledged"
  depends_on = [kubernetes_namespace.kube-fledged]
}

resource "helm_release" "kubernetes-dashboard" {
  name       = "kubernetes-dashboard"

  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"

  namespace = "kubernetes-dashboard"
  depends_on = [kubernetes_namespace.kubernetes-dashboard]

  values = ["${file("helm/kubernetes-dashboard.values.yaml")}"]
}

resource "helm_release" "vpa" {
  name       = "vpa"

  repository = "https://charts.fairwinds.com/stable"
  chart      = "vpa"

  namespace = "vpa"
  depends_on = [kubernetes_namespace.vpa]
}

resource "helm_release" "goldilocks" {
  name       = "goldilocks"

  repository = "https://charts.fairwinds.com/stable"
  chart      = "goldilocks"

  namespace = "goldilocks"
  depends_on = [kubernetes_namespace.goldilocks]
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
  depends_on = [kubernetes_namespace.rbac-manager]
}

resource "helm_release" "kyverno-crds" {
  name       = "kyverno-crds"

  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno-crds"

  namespace = "kyverno"
  depends_on = [kubernetes_namespace.kyverno]
}

resource "helm_release" "kyverno" {
  name       = "kyverno"

  repository = "https://kyverno.github.io/kyverno/"
  chart      = "kyverno"

  namespace = "kyverno"
  depends_on = [kubernetes_namespace.kyverno, helm_release.kyverno-crds]
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
    kubernetes_priority_class.monitor-priority-class,
    kubernetes_namespace.datadog
  ]
}