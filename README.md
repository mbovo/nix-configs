# home-manager configuration

This is my personal configuration for home-manager on darwin systems (macOS).

First steps on `nix` world, I'm currently not using `nix-darwin` but just `home-manager` to install utilities I need day by day.

I'm using `direnv` and `nix develop` or `devbox` to manage my development environment.

## Directory Structure:

```
.
├── common                                # configurations and modules shared across all hosts
│  ├── dotfiles                           # dotfiles (some of them encrypted)
│  └── nix                                # nix home-manager modules
│     ├── cli-tools.nix                   # all tools and cli utilities I use
│     ├── common.nix                      # main entry point
│     ├── darwin.nix                      # darwin specific configuration  (yabai, skhd, ...)
│     ├── docker.nix                      # docker pkgs and configurations
│     ├── git.nix                         # git pkgs and configurations
│     ├── kubernetes.nix                  # kubernetes pkgs and configurations
│     ├── python.nix                      # python pkgs and configurations
│     ├── sec-tools.nix                   # security tools pkgs and configurations
│     └── zsh.nix                         # zsh pkgs and configurations (oh-my-zsh, theme and such)
├── flake.nix                             # entrypoint
├── hosts                                 # each directory represent an overlay for specifc host
│  └── $hostname
│     ├── dotfiles                        # dotfiles specific for this host
│     ├── nix
│     │  ├── cloud-providers.nix          # cloud providers pkgs and configurations
│     │  ├── dev-tools.nix                # dev tools pkgs and configurations
│     │  ├── git-extra.nix                # git extra pkgs and configurations
│     └──└── kubernetes-extra.nix         # kubernetes extra pkgs and configurations
└── README.md
```
