# home-manager configuration

This is my personal configuration for home-manager.

First steps on `nix` world, I'm currently just using `home-manager` to install utilities I need day by day.

I'm using `direnv` and `nix develop` or `devbox` to manage my development environments.

## Directory Structure:

```
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