### Internal Tooling:
- [Velero](http://velero.io) (Kubernetes Backup and Restore System)
- [Chaoskube](https://github.com/linki/chaoskube) (Kubernetes Implementation of Netflix's Chaos Monkey for Pods, randomly kills pod in cluster every X minutes)
- [Descheduler](https://github.com/kubernetes-sigs/descheduler) (An opinionated descheduler for kubernetes that will kill pods on nodes and allow for automatic rescheduling by the Kube scheduler)
- [Kubefledged](https://github.com/senthilrch/kube-fledged) (An image caching system for kubernetes that will precache images on nodes to allow for faster startup)
- [Kruise](https://github.com/openkruise/kruise/blob/master/README.md) (Advanced Application Management, used personally primarily for Sidecar Injection)
- [Metrics Server](https://github.com/kubernetes-sigs/metrics-server) (Metric Aggregation Server used to collect pod and node metrics about CPU and Memory usage for use with HPA scalers)
- [Rbac Manager](https://rbac-manager.docs.fairwinds.com/introduction/#the-benefits) (Easy management for Kubernetes RBAC to ensure secure access to Kubernetes for team members)
- [Kyverno](https://kyverno.io) (Kubernetes Government Control for enforcing consistency amongst deployments and best practices)
- [Datadog](https://www.datadoghq.com) (All encompassing monitoring system for kubernetes with easy log management, apm, npm, etc.)


### Internal Application Services (Access Management done via [Cloudflare Access](https://www.cloudflare.com/en-gb/teams/access/) to prevent having to use VPN system):
- [Litmus](https://litmuschaos.io) (Full Scale Chaos Management System for complex workflows)
- [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) (Easy to use hosted Kubernetes Dashboard for visibility and quick management of resources)
- [VPA & Goldilocks](https://github.com/FairwindsOps/goldilocks) (Scaling Recommendation Dashboard providing insights into recommended request and limit requests for application deployments)
- [HAProxy Ingress](http://www.haproxy.org) (Ingress Manager for Cloudflare Access domains to allow for easier management via Ingress objects as opposed to configmaps)
- [Cloudflare Argo](https://www.cloudflare.com/en-gb/products/argo-smart-routing/) (Cloudflare Argo tunneling system to ensure connections to internal applications protected by cloudflare access actually come via the cloudflare network to ensure security)


### External Services:
- [Nginx](https://nginx.org) (Externally Facing Ingress for Management of Public Services)
- [OpenResty](https://openresty.org/en/) (Nginx Extensibility Framework allowing management of third party lua scripts)
- [Cert Manager](https://cert-manager.io) (Lets Encrypt Certificate Management for Nginx)