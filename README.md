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
3. Access to the private repository: a local checkout passed with `--priv-dir DIR`, or an SSH key to clone it (optional, see [Private configuration](#private-configuration))

### Bootstrap a bare machine

```bash
git clone https://github.com/mbovo/nix-configs.git ~/oss/nix-configs
git clone git@github.com:mbovo/nix-configs-priv.git ~/oss/nix-configs-priv
~/oss/nix-configs/ansible/install.sh --priv-dir ~/oss/nix-configs-priv --check   # optional dry run, no sudo
~/oss/nix-configs/ansible/install.sh --priv-dir ~/oss/nix-configs-priv           # asks for the sudo password once, to create the Homebrew prefix
```

`install.sh` runs these steps:

1. `bootstrap.sh` builds `ansible/.venv` with pure Python and Poetry. Poetry downloads a standalone Python 3.12+ if the system one is too old. The Ansible collections are installed too.
2. It picks the inventory host whose `home_username` matches the current user, or the one given with `--host`.
3. `playbooks/bootstrap.yml` installs Homebrew, uses (or clones) the private repo and installs sops/age.
4. `playbooks/site.yml` applies the configuration, the equivalent of `home-manager switch`.

Re-run it at any time to apply changes; it is idempotent. Options:

```bash
./install.sh --priv-dir ~/oss/nix-configs-priv   # use an existing private checkout (recommended)
./install.sh --priv-ssh-key ~/.ssh/id_ed25519    # no --priv-dir: clone the private repo with this key
./install.sh --no-priv                           # skip the private configuration
./install.sh --host mbp                  # force the inventory host
./install.sh --check                     # dry run (--check --diff)
./install.sh --uninstall [--check]       # see Uninstall below
./install.sh --setup-only                # only (re)build the virtualenv
./install.sh -- --tags git,shells        # anything after -- goes to ansible-playbook
```

The options can be combined, e.g. `./install.sh --priv-dir ~/oss/nix-configs-priv --check -- --tags git`.

### Private configuration

The Brewfile, the secrets, private files and optional host overrides (`hosts/<host>/ansible.yml`) come from `nix-configs-priv`. By default an existing checkout is used; without one, the repository is cloned with git:

| option | variable | behaviour |
| --- | --- | --- |
| `--priv-dir DIR` | `priv_config_local_dir: DIR` (makes `priv_config_source` default to `local`) | use a checkout you already have; it is never pulled, modified or removed by uninstall |
| _(no directory given)_ | `priv_config_source: git` | clone into `~/.local/share/nix-configs-priv` using the ssh agent / `~/.ssh` keys |
| `--priv-ssh-key PATH` | `priv_config_ssh_key: PATH` | private key for that clone |
| `--no-priv` | `priv_config_source: none` | skip it; everything that depends on it is skipped with a warning |

The options apply to a single run. To make a choice permanent, set the variables in `ansible/inventory/host_vars/<host>.yml`, e.g. `priv_config_local_dir: ~/oss/nix-configs-priv`.

`nix-configs-priv/hosts/<host>/ansible.yml` replaces that host's `default.nix`. It is loaded before every role, so it can set any role variable. Paths can use `priv_config_host_dir` / `priv_config_common_dir`. The variables used so far:

| variable | nix equivalent |
| --- | --- |
| `sops_secrets: [{name, sops_file, path, mode}]` | `sops.secrets` (sops binary files, decrypted with `~/.config/sops/age/keys.txt`; default mode `0400`) |
| `priv_config_files: [{src, dest, mode}]` | `home.file` for plain files (`dest` relative to `$HOME`) |
| `docker_config_daemon` / `docker_config_file` | `custom.docker.config.daemon` / `.file` (the latter sops-encrypted) |
| `cloud_providers_aws_extra_config` | `custom.cloudProviders.aws.extraConfig` (sops-encrypted) |
| `ssh_match_blocks` | `custom.ssh.matchBlocks` (use ssh_config keywords: `ForwardAgent: true`) |
| `git_includes: [{condition, path}]` | `programs.git.includes` |

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
./install.sh --priv-dir ~/oss/nix-configs-priv --uninstall --check              # show what would be removed/restored
./install.sh --priv-dir ~/oss/nix-configs-priv --uninstall                      # asks for sudo only if Homebrew itself will be removed
./install.sh --priv-dir ~/oss/nix-configs-priv --uninstall -- --tags files      # only restore dotfiles
./install.sh --priv-dir ~/oss/nix-configs-priv --uninstall -- --tags packages   # only remove packages
```

Pass the same `--priv-dir` used for the install so the host overrides load; the checkout itself is left untouched.

Homebrew itself is removed only if Ansible installed it and nothing installed outside Ansible remains. To remove it anyway, add `-e homebrew_uninstall_force=true`. The age key is never deleted.

### Notes

- **Intel Macs (x86_64):** Homebrew supports them only at Tier 3, so formulae without an Intel bottle are compiled from source. To list them: `cd ansible && .venv/bin/python scripts/check_brew_bottles.py --arch x86_64 <formula...>`
- **Nixpkgs-only tools:** `devbox`, `nix-direnv`, `hping`, `nil`, `nvd`, `nix-diff` and `nix-output-monitor` aren't in Homebrew. They're installed with `nix profile` when nix is present, otherwise skipped.
- **New host:** add it to `ansible/inventory/hosts.yml` (groups `desktop`/`darwin`) and create `ansible/inventory/host_vars/<host>.yml` with at least `home_username`.
- **Lint:** `cd ansible && .venv/bin/ansible-lint playbooks/ roles/`
