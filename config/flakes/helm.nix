{
  description = "generic helm flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { ...}@inputs: inputs.flake-utils.lib.eachDefaultSystem(
    system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      formatter = pkgs.nixfmt-rfc-style;
    in {
      formatter = formatter;

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          pre-commit
          kubernetes-helm
          kubeconform
        ];
        postShellHook = ''
          which kubeconform
          which helm
          helm version
        '';
      };
    }
  );
}