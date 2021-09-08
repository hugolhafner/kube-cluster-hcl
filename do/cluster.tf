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

resource "kubernetes_priority_class" "development-priority-class" {
  metadata {
    name = "development-priority-class"
  }

  value = 2000
  global_default = false
  description = "Development Priority class to ensure preferred scheduling on nodes over default environments."
}

resource "kubernetes_priority_class" "staging-priority-class" {
  metadata {
    name = "staging-priority-class"
  }

  value = 3000
  global_default = false
  description = "Staging Priority class to ensure preferred scheduling on nodes over development and default environments."
}

resource "kubernetes_priority_class" "canary-priority-class" {
  metadata {
    name = "canary-priority-class"
  }

  value = 4000
  global_default = false
  description = "Canary Priority class to ensure preferred scheduling on nodes over development and default environments."
}

resource "kubernetes_priority_class" "production-priority-class" {
  metadata {
    name = "production-priority-class"
  }

  value = 4000
  global_default = false
  description = "Production Priority class to ensure preferred scheduling on nodes over development and default environments."
}

resource "kubernetes_priority_class" "monitor-priority-class" {
  metadata {
    name = "monitor-priority-class"
  }

  value = 5000
  global_default = false
  description = "Monitoring Priority class to ensure scheduling on nodes."
}

resource "kubernetes_priority_class" "cluster-priority-class" {
  metadata {
    name = "cluster-priority-class"
  }

  value = 10000
  global_default = false
  description = "Cluster Priority class to ensure scheduling on nodes."
}

resource "kubernetes_config_map" "allowed-priority-classes" {
  metadata {
    name = "allowed-priority-classes"
    namespace = "default"
  }

  data = {
    "development-priority-class" = "true"
     "staging-priority-class" = "true"
     "canary-priority-class" = "true"
     "production-priority-class" = "true"
     "monitor-priority-class" = "true"
     "cluster-priority-class" = "true"
  }
}