# home-manager configuration

This is my personal configuration for home-manager.

First steps on `nix` world, I'm currently just using `home-manager` to install utilities I need day by day.

I'm using `direnv` and `nix develop` or `devbox` to manage my development environments.

## Directory Structure

```bash
.
├── common                                # configurations and modules shared across all hosts
│  ├── cli-tools.nix                   # all tools and cli utilities I use
│  ├── common.nix                      # main entry point
│  ├── darwin.nix                      # darwin specific configuration  (yabai, skhd, ...)
│  ├── docker.nix                      # docker pkgs and configurations
│  ├── git.nix                         # git pkgs and configurations
│  ├── kubernetes.nix                  # kubernetes pkgs and configurations
│  ├── python.nix                      # python pkgs and configurations
│  ├── sec-tools.nix                   # security tools pkgs and configurations
│  └── zsh.nix                         # zsh pkgs and configurations (oh-my-zsh, theme and such)
├── flake.nix                             # entrypoint
└── README.md
```

Dotfiles and secrets are sops-encryted and stored in a private repository.

## How to bootstrap a new host

1. Install `nix` and `home-manager` (depends on target OS)
2. Clone this repository
3. Run `nix develop` enter a development environment
4. Generate age key for this host ```age-keygen -o ~/.config/sops/age/keys.txt```
5. Add the public key to sops config of the private repository and re-encrypt everything/prepare the secrets for this host
6. Run `gh auth login` to authenticate with GitHub and create a private key for the host
7. Run `home-manager` (`nh home switch`) to apply the configuration

## Keep it update

```bash
nix flake update
nh home build .

# If there are no errors
nh home switch .
```
