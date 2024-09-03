{ config, pkgs, ...}@inputs:

{
  home = {
    packages = with pkgs; [
      # Containers & Kubernetes
      clusterctl
      fluxcd
      kind
      krew
      kubeconform
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      kyverno
      stern
    ];
  };
}