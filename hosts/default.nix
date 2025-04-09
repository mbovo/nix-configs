{inputs, outputs, self,...}@args:
let 
  # default paths for all systems
  paths = {
    home = rec {
      x86_64-darwin = "/Users/";
      aarch64-darwin = x86_64-darwin;
      x86_64-linux = "/home/";
      aarch64-linux = x86_64-linux;
    };
  };
in
{


    # ==================================================================================================================
    # work MacOs configuration
    # ==================================================================================================================
    "manuelbovo@M-PA-LT75QJ7NN7" = inputs.home-manager.lib.homeManagerConfiguration (
       import ./entrypoint.nix {
        system = "aarch64-darwin";
        hostname = "M-PA-LT75QJ7NN7";
        username = "manuelbovo";
        usepkgs = inputs.nixpkgs-stable-darwin;
        lib = inputs.nixpkgs-stable-darwin.lib;
        inherit inputs outputs self paths;
      }
    );

    # ==================================================================================================================
    # personal MacOs configuration
    # ==================================================================================================================
    "manuel@mbp.local" = inputs.home-manager.lib.homeManagerConfiguration (
      import ./entrypoint.nix {
        system = "x86_64-darwin";
        hostname = "mbp";
        username = "manuel";
        usepkgs = inputs.nixpkgs-stable-darwin;
        lib = inputs.nixpkgs-stable-darwin.lib;
        inherit inputs outputs self paths;
      }
    );
}