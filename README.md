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

Inventory hosts are `mbp` and `M-PA-LT75QJ7NN7`. They don't match `hostname`: `install.sh` picks the host from the current user, and plain `ansible-playbook` needs `-l <host>`.

### Prerequisites

1. Xcode Command Line Tools: `xcode-select --install` (provides `git`, `python3` and `bash`, the only tools needed)
2. The age key at `~/.config/sops/age/keys.txt` (secrets are skipped with a warning until it exists)
3. An SSH key with access to the private repository

### Bootstrap a bare machine

```bash
git clone https://github.com/mbovo/nix-configs.git ~/oss/nix-configs
~/oss/nix-configs/ansible/install.sh --check   # optional dry run, no sudo
~/oss/nix-configs/ansible/install.sh           # asks for the sudo password once, to create the Homebrew prefix
```

`install.sh` runs these steps:

1. `bootstrap.sh` builds `ansible/.venv` with pure Python and Poetry. Poetry downloads a standalone Python 3.12+ if the system one is too old. The Ansible collections are installed too.
2. It picks the inventory host whose `home_username` matches the current user, or the one given with `--host`.
3. `playbooks/bootstrap.yml` installs Homebrew, clones the private repo and installs sops/age.
4. `playbooks/site.yml` applies the configuration, the equivalent of `home-manager switch`.

Re-run it at any time to apply changes; it is idempotent. Options:

```bash
./install.sh --host mbp                  # force the inventory host
./install.sh --check                     # dry run (--check --diff)
./install.sh --uninstall [--check]       # see Uninstall below
./install.sh --setup-only                # only (re)build the virtualenv
./install.sh -- --tags git,shells        # anything after -- goes to ansible-playbook
```

Role tags match the role names (`cli_tools`, `git`, `shells`, `k8s`, ...). Finer tags are also available, e.g. `zsh`, `atuin`, `modern`, `python`, `aws`.

On a machine without Homebrew, the dry run can only simulate `bootstrap.yml`: `site.yml` stops early because there is no brew to query yet.

The playbooks can also be run directly from `ansible/`, e.g. `.venv/bin/ansible-playbook playbooks/site.yml -l mbp --check --diff`. If [go-task](https://taskfile.dev) is installed, there are `task ansible:*` shortcuts too (see [Taskfile.yml](./Taskfile.yml)).

### Uninstall

Ansible keeps a record of what it did in `~/.local/state/nix-configs-ansible/`:

- the formulae, casks, nix and pip packages it installed (anything already present is never recorded)
- every file it wrote, with a backup of whatever was there before (regular files and symlinks, e.g. home-manager links)
- the Homebrew directories it created

`playbooks/uninstall.yml` uses that record to remove only what Ansible added. It then restores the previous files and deletes the empty directories it had created:

```bash
./install.sh --uninstall --check              # show what would be removed/restored
./install.sh --uninstall                      # asks for sudo only if Homebrew itself will be removed
./install.sh --uninstall -- --tags files      # only restore dotfiles
./install.sh --uninstall -- --tags packages   # only remove packages
```

Homebrew itself is removed only if Ansible installed it and nothing installed outside Ansible remains. To remove it anyway, add `-e homebrew_uninstall_force=true`. The age key is never deleted.

### Notes

- **Intel Macs (x86_64):** Homebrew supports them only at Tier 3, so formulae without an Intel bottle are compiled from source. To list them: `cd ansible && .venv/bin/python scripts/check_brew_bottles.py --arch x86_64 <formula...>`
- **Nixpkgs-only tools:** `nix-direnv`, `hping`, `nil`, `nvd`, `nix-diff` and `nix-output-monitor` aren't in Homebrew. They're installed with `nix profile` when nix is present, otherwise skipped.
- **New host:** add it to `ansible/inventory/hosts.yml` (groups `desktop`/`darwin`) and create `ansible/inventory/host_vars/<host>.yml` with at least `home_username`.
- **Lint:** `cd ansible && .venv/bin/ansible-lint playbooks/ roles/`
