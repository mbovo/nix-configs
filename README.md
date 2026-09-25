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

### Custpm home-manager options

See [README.md](./modules/home-manager/README.md) for a list of custom options.

## Ansible (Homebrew-based alternative)

The [ansible/](./ansible) directory reproduces the same setup without nix: packages come from Homebrew, and dotfiles and sops secrets are placed in the same locations home-manager uses.

| nix | ansible |
| --- | --- |
| `modules/home-manager/<module>` | `ansible/roles/<module>` |
| `hosts/0-type-desktop.nix` | `ansible/inventory/group_vars/desktop.yml` |
| `hosts/1-system-darwin.nix` | `ansible/inventory/group_vars/darwin.yml` |
| `hosts/2-host-<host>.nix` | `ansible/inventory/host_vars/<host>.yml` |
| `nix-configs-priv/hosts/<host>` | `nix-configs-priv/hosts/<host>/ansible.yml` (optional, loaded if present) |

Inventory hosts are `mbp` and `M-PA-LT75QJ7NN7`. They don't match `hostname`, so always pick one with `-l`/`HOST=`.

### Prerequisites

1. Xcode Command Line Tools: `xcode-select --install`
2. The age key at `~/.config/sops/age/keys.txt` (secrets are skipped with a warning until it exists)
3. An SSH key with access to the private repository (`gh auth login`)

### Setup

Creates `ansible/.venv` with Poetry and a Python 3.12+ interpreter. Poetry installs one if the system has none. It also installs the collections required by the roles.

```bash
task ansible:setup        # or: cd ansible && ./bootstrap.sh
```

### Apply

```bash
# First run only: installs Homebrew (asks for the sudo password), clones the private repo, installs sops/age
task ansible:bootstrap HOST=mbp

# Equivalent of `home-manager switch`
task ansible:apply HOST=mbp
```

Or directly from `ansible/`:

```bash
.venv/bin/ansible-playbook playbooks/bootstrap.yml -l mbp -K
.venv/bin/ansible-playbook playbooks/site.yml -l mbp
.venv/bin/ansible-playbook playbooks/site.yml -l mbp --tags git,shells   # only some roles
```

Role tags match the role names (`cli_tools`, `git`, `shells`, `k8s`, ...). Finer tags are also available, e.g. `zsh`, `atuin`, `modern`, `python`, `aws`.

### Dry run

All playbooks support `--check --diff`. A dry run changes nothing and needs no sudo password:

```bash
task ansible:bootstrap:dry-run HOST=mbp
task ansible:apply:dry-run HOST=mbp
task ansible:uninstall:dry-run HOST=mbp
```

Before Homebrew exists, the apply dry run stops early. Dry-run the bootstrap instead.

### Uninstall

Ansible keeps a record of what it did in `~/.local/state/nix-configs-ansible/`:

- the formulae, casks, nix and pip packages it installed (anything already present is never recorded)
- every file it wrote, with a backup of whatever was there before (regular files and symlinks, e.g. home-manager links)
- the Homebrew directories it created

`playbooks/uninstall.yml` uses that record to remove only what Ansible added. It then restores the previous files and deletes the empty directories it had created:

```bash
task ansible:uninstall HOST=mbp          # asks for sudo, needed to remove Homebrew itself
.venv/bin/ansible-playbook playbooks/uninstall.yml -l mbp -K --tags files      # only restore dotfiles
.venv/bin/ansible-playbook playbooks/uninstall.yml -l mbp -K --tags packages   # only remove packages
```

Homebrew itself is removed only if Ansible installed it and nothing installed outside Ansible remains. To remove it anyway, add `-e homebrew_uninstall_force=true`. The age key is never deleted.

### Notes

- **Intel Macs (x86_64):** Homebrew supports them only at Tier 3, so formulae without an Intel bottle are compiled from source. To list them: `cd ansible && .venv/bin/python scripts/check_brew_bottles.py --arch x86_64 <formula...>`
- **Nixpkgs-only tools:** `nix-direnv`, `hping`, `nil`, `nvd`, `nix-diff` and `nix-output-monitor` aren't in Homebrew. They're installed with `nix profile` when nix is present, otherwise skipped.
- **New host:** add it to `ansible/inventory/hosts.yml` (groups `desktop`/`darwin`) and create `ansible/inventory/host_vars/<host>.yml` with at least `home_username`.
- **Lint:** `task ansible:lint`
