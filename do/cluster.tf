resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = "${var.cluster_region}-${random_id.random.hex}"
  region  = var.cluster_region
  version = "1.21.2-do.2"

  node_pool {
    name       = var.node_pool.name
    size       = var.node_pool.machine_type
    auto_scale = true
    min_nodes  = var.node_pool.min_nodes
    max_nodes  = var.node_pool.max_nodes
  }
}

provider "kubernetes" {
  host             = digitalocean_kubernetes_cluster.cluster.endpoint
  token            = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
  )

  experiments {
    manifest_resource = true
  }
}

resource "kubernetes_priority_class" "default-priority-class" {
  metadata {
    name = "default-priority-class"
  }

  value = 1000
  global_default = true
  description = "Default priority class for all pods"
}

resource "kubernetes_priority_class" "cluster-monitor" {
  metadata {
    name = "cluster-monitor"
  }

  value = 2000
  global_default = false
  description = "Monitoring Priority class to ensure scheduling on nodes."
}

// Custom namespace for datadog to allow for golidlocks annotation
resource "kubernetes_namespace" "datadog" {
  count = var.datadog.enabled ? 1 : 0

  metadata {
    labels = {
      "goldilocks.fairwinds.com/enabled" = true
    }

    name = "datadog"
  }
}
