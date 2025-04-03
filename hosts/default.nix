{inputs, outputs, ...}@args:
let 
# defaults modules for all systems
      mods = {
        common = [ inputs.sops-nix.homeManagerModules.sops ../common/default.nix ];
        darwin = [ ../common/darwin.nix ];
        linux  = [ ../common/linux.nix ];
      };
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
    # new work MacOs configuration
    # ==================================================================================================================
    "manuelbovo@M-PA-LT75QJ7NN7" = inputs.home-manager.lib.homeManagerConfiguration (
      import ./M-PA-LT75QJ7NN7.nix {inherit inputs outputs paths mods;}
    );

    # # ==================================================================================================================
    # # personal MacOs configuration
    # # ==================================================================================================================
    "manuel@mbp.local" = inputs.home-manager.lib.homeManagerConfiguration (
      import ./mbp.local.nix {inherit inputs outputs paths mods;}
    );
}