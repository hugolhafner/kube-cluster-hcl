variable "do_token" {}

variable "cluster_region" {
  type = string
}

variable "node_pool" {
  type = object({
    name = string
    min_nodes = number
    max_nodes = number
    machine_type = string
    labels = map(string)
  })

  default = {
    labels = {}
    machine_type = "s-8vcpu-16gb"
    max_nodes = 5
    min_nodes = 3
    name = "worker-pool"
  }
}

variable "datadog" {
  type = object({
    enabled = bool
    api_key = string
  })

  default = {
    enabled = false
    api_key = ""
  }
}

variable "velero" {
  type = object({
    key = string
    secret = string
    bucket = string
  })
}

variable "argo" {
  type = object({
    hostname = string
    tunnel = string
  })

  default = {
    hostname = "hugohafner.com"
    tunnel = "kubernetes-tunnel"
  }
}