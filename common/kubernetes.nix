{ config, pkgs, priv-config, ...}@inputs:

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
    file = {
        "krew_list".source = "${priv-config}/common/krew_list";
      };
  };
}