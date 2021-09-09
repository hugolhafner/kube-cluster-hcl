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
- [Kubernetes Dashboard](https://github.com/kubernetes/dashboard) (Easy to use hosted Kubernetes Dashboard for visibility and quick management of resources)
- [VPA & Goldilocks](https://github.com/FairwindsOps/goldilocks) (Scaling Recommendation Dashboard providing insights into recommended request and limit requests for application deployments)
- [Nginx Ingress](http://nginx.org) (Ingress Manager for Cloudflare Access domains to allow for easier management via Ingress objects as opposed to configmaps)
- [Cloudflare Argo](https://www.cloudflare.com/en-gb/products/argo-smart-routing/) (Cloudflare Argo tunneling system to ensure connections to internal applications protected by cloudflare access actually come via the cloudflare network to ensure security)
- [ArgoCD](https://argoproj.github.io/) (CI/CD Platform for Kubernetes applications)


### External Services:
- [Nginx](https://nginx.org) (Externally Facing Ingress for Management of Public Services)
- [OpenResty](https://openresty.org/en/) (Nginx Extensibility Framework allowing management of third party lua scripts)
- [Cert Manager](https://cert-manager.io) (Lets Encrypt Certificate Management for Nginx)


### Government Labels:
#### Deployments
- `"distribute=true"` Best effort spreads out deployment pods by node `"topology.kubernetes.io/zone"` label, will schedule deployment regardless if unable to fulfill request

#### Namespaces
- `"exec=false"` Disables executing into a pod for everyone except cluster-admins in the labelled namespace
- `"ingress=true"` Allows Load Balancers to be created within that namespace, otherwise are by default denied everywhere
- `"protected=true"` resources are unable to be deleted or changed by people with roles other than cluster-admins  # TODO: Add CI/CD support

### Government Policies:
- Namespaces by default are assigned a default-deny network policy blocks all ingress and egress traffic
- Default namespace is not allowed for pods to be scheduled on
- Secrets cannot be mounted as environment variables into pods, instead must be mounted as volumes
- Host path volumes are forbidden on all pods
- Use of host ports is disallowed for all containers and initContainers
- Services of type NodePort are not allowed
- Priority classes are automatically assigned to pods depending on environment, development, staging, canary, production and monitor
- Images are not allowed to be using the latest tag
- Deployments should have at least 3 replicas to ensure availability
- Root users are not allowed for pods in namespaces other than kube-system
- Liveness and Readiness probes are required
- Liveness and Readiness probes are not allowed to be the same
- CPU and memory requests and limits are required
- Ingress class values are only supported to be "nginx" and "argo"
- "regcred" secret is synced from default namespace to all other namespaces automatically
- Ingresses require unique host names
- Pod priorities are only allowed to be set if the priority class is set in the allowed-priority-classes configmap in the default namespace

### Government Notes:
- These have not been thoroughly tested or validated as of yet and as such may not be fully functional and ready for production use.

###### Known Issues
- Helm deployments are made before kyverno government policies and as such some may be in violation