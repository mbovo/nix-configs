# home-manager configuration

This is my personal configuration for home-manager.

First steps on `nix` world, I'm currently just using `home-manager` to install utilities I need day by day.

I'm using `direnv` and `nix develop` or `devbox` to manage my development environments.

Dotfiles and secrets are sops-encryted and stored in a private repository.

## How to bootstrap a new host

1. Install `nix` and `home-manager` (depends on target OS)
2. Clone this repository
3. Run `nix develop` enter a development environment
4. Generate age key for this host ```age-keygen -o ~/.config/sops/age/keys.txt```
5. Add the public key to sops config of the private repository and re-encrypt everything/prepare the secrets for this host
6. Run `gh auth login` to authenticate with GitHub and create a private key for the host
7. Create a file `~/hosts/$(hostname).nix` with the following content:
    ```nix
    { config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
    {
      # common configurations, if you don't want to use them, remove the import but you'll need to 
      # define at least the following:
      # # home = {
      # #   inherit username homeDirectory;
        
      # #   keyboard.layout = "it";
      # #   stateVersion = "23.11";
      # # }
      imports = [
        ./common.nix
      ];
    }
    ```
8. Run `home-manager` (`nh home build`) to verify the configuration
9. If everything is ok, run `nh home switch .` to apply the configuration

## Keep it update

```bash
nix flake update
nh home build .

# If there are no errors
nh home switch .
```
