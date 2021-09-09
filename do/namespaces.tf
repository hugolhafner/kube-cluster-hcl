resource "kubernetes_namespace" "velero" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "velero"
  }
}

resource "kubernetes_namespace" "kruise" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "kruise"
  }
}

resource "kubernetes_namespace" "argo" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "argo"
  }
}

resource "kubernetes_namespace" "chaoskube" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "chaoskube"
  }
}

resource "kubernetes_namespace" "nginx-staging" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "ingress" = true
      "environment" = "staging"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "nginx-staging"
  }
}

resource "kubernetes_namespace" "nginx-canary" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "ingress" = true
      "environment" = "canary"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "nginx-canary"
  }
}

resource "kubernetes_namespace" "nginx-production" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "ingress" = true
      "environment" = "production"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "nginx-production"
  }
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "cert-manager"
  }
}

resource "kubernetes_namespace" "kube-fledged" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "kube-fledged"
  }
}

resource "kubernetes_namespace" "kubernetes-dashboard" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "monitor"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "kubernetes-dashboard"
  }
}

resource "kubernetes_namespace" "vpa" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "vpa"
  }
}

resource "kubernetes_namespace" "goldilocks" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "monitor"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "goldilocks"
  }
}

resource "kubernetes_namespace" "rbac-manager" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "rbac-manager"
  }
}

resource "kubernetes_namespace" "kyverno" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "kyverno"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    labels = {
      "exec" = false
      "protected" = true
      "environment" = "system"
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "argocd"
  }
}

resource "kubernetes_namespace" "datadog" {
  count = var.datadog.enabled ? 1 : 0

  metadata {
    labels = {
      "goldilocks.fairwinds.com/enabled" = true
      "exec" = false
      "protected" = true
      "environment" = "system"
    }

    name = "datadog"
  }
}