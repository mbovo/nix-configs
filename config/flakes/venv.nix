{
  description = "generic venv flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { ...}@inputs: inputs.flake-utils.lib.eachDefaultSystem(
    system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      formatter = pkgs.nixfmt-rfc-style;
      python = pkgs.python311;
      venv = "./.venv";
    in {
      formatter = formatter;

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          pre-commit
        ];
        buildInputs = with pkgs.python311Packages; [
          python
          venvShellHook
        ];
        venvDir = venv;
        postVenvCreation = ''
          unset SOURCE_DATE_EPOCH
          python -m venv .venv --prompt $(echo $PWD | sed 's?.*prjs/\([-a-zA-z0-9]*\)/.*?\1?') --upgrade-deps
          poetry env use ${venv}/bin/python
          poetry install --no-root
        '';
        postShellHook = ''
          unset SOURCE_DATE_EPOCH
          poetry env info
        '';
        PYTHONDONTWRITEBYTECODE = 1;
        POETRY_VIRTUALENVS_IN_PROJECT = 1;
      };
    }
  );
}

