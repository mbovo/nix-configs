{config, pkgs, ...}@inputs:

{
  home = {
    packages = with pkgs; [
      # Certificates & Encryption & Secrets
      cfssl
      age
      gnupg24
      sops
      bitwarden-cli
    ];
  };
}