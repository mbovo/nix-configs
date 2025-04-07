# k8s-clients Module Options

| Option | Description | Type | Default |
|--------|-------------|------|---------|
| `custom.k8s.enable` |  | bool | false |
| `custom.k8s.packages` |  | listOf | [
        pkgs.kubectl
        pkgs.kubectx
        pkgs.kustomize
        pkgs.krew
        pkgs.kubernetes-helm
      ] |
| `custom.k8s.extra.enable` |  | bool | false |
| `custom.k8s.extra.packages` |  | listOf | [
          pkgs.kind
          pkgs.stern
          pkgs.kubeconform
        ] |
| `custom.k8s.extra.clusterctl.enable` |  | bool | false |
| `custom.k8s.extra.clusterctl.package` |  | package | pkgs.clusterctl |
| `custom.k8s.extra.kyverno.enable` |  | bool | false |
| `custom.k8s.extra.kyverno.package` |  | package | pkgs.kyverno |
| `custom.k8s.extra.fluxcd.enable` |  | bool | false |
| `custom.k8s.extra.fluxcd.package` |  | package | pkgs.fluxcd |
| `custom.k8s.extra.argocd.enable` |  | bool | false |
| `custom.k8s.extra.argocd.package` |  | package | pkgs.argocd |
