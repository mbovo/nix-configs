{inputs, outputs, ...}@args:
let 
  # default paths for all systems
  paths = {
    home = {
      x86_64-darwin = "/Users/";
      aarch64-darwin = "/Users/";
      x86_64-linux = "/home/";
      aarch64-linux = "/home/";
    };
  };
in
{


    # ==================================================================================================================
    # work MacOs configuration
    # ==================================================================================================================
    "manuelbovo@M-PA-LT75QJ7NN7" = inputs.home-manager.lib.homeManagerConfiguration (
       import ./generic-darwin.nix {
        system = "aarch64-darwin";
        hostname = "M-PA-LT75QJ7NN7";
        username = "manuelbovo";
        inherit inputs outputs paths;
      }
    );

    # ==================================================================================================================
    # personal MacOs configuration
    # ==================================================================================================================
    "manuel@mbp.local" = inputs.home-manager.lib.homeManagerConfiguration (
      import ./generic-darwin.nix {
        system = "x86_64-darwin";
        hostname = "mbp";
        username = "manuel";
        inherit inputs outputs paths;
      }
    );
}