# home-manager modules

## aws Module Options

| Option | Description | Type | Default |
|--------|-------------|------|---------|
| `custom.cloudProviders.aws.package` | Default package to use for installing awscli | package | pkgs.awscli2 |
| `custom.cloudProviders.aws.extraPackages` | List of extra packages to add with | listOf package | [ pkgs.eksctl pkgs.steampipe ] |
| `custom.cloudProviders.aws.extraConfig` |  | nullOr path | null |
| `custom.docker.package` | Default docker package to install | package | pkgs.docker |
| `custom.docker.darwin.packages` | List of package to install when on MacOs | listOf package | [pkgs.qemu pkgs.lima pkgs.colima] |
| `custom.docker.extra.enable` |  | bool | config.custom.docker.enable |
| `custom.docker.extra.packages` |  | listOf package | [pkgs.docker-compose pkgs.docker-buildx pkgs.dive] |
| `custom.docker.config.daemon` |  | nullOr path| null |
| `custom.docker.config.file` |  | nullOr path | null |
| `custom.k8s.enable` |  | bool | false |
| `custom.k8s.packages` |  | listOf package| [ pkgs.kubectl pkgs.kubectx pkgs.kustomize pkgs.krew pkgs.kubernetes-helm ] |
| `custom.k8s.extra.enable` |  | bool | false |
| `custom.k8s.extra.packages` |  | listOf package| [ pkgs.kind pkgs.stern pkgs.kubeconform ] |
| `custom.k8s.extra.clusterctl.enable` |  | bool | false |
| `custom.k8s.extra.clusterctl.package` |  | package | pkgs.clusterctl |
| `custom.k8s.extra.kyverno.enable` |  | bool | false |
| `custom.k8s.extra.kyverno.package` |  | package | pkgs.kyverno |
| `custom.k8s.extra.fluxcd.enable` |  | bool | false |
| `custom.k8s.extra.fluxcd.package` |  | package | pkgs.fluxcd |
| `custom.k8s.extra.argocd.enable` |  | bool | false |
| `custom.k8s.extra.argocd.package` |  | package | pkgs.argocd |
| `custom.shells.atuin.package` |  | package | pkgs.atuin |
| `custom.shells.atuin.config` |  | nullOr path| null |
| `custom.shells.atuin.key` |  | nullOr path| null |
| `custom.brew.enable` |  | bool | false |
| `custom.brew.config_file` |  | nullOr path| null |
| `custom.secTools.packages` |  | listOf package| [ pkgs.cfssl pkgs.age pkgs.gnupg24 pkgs.sops ] |
| `custom.secTools.extra.packages` |  | listOf package| [ pkgs.bitwarden-cli ] |
| `custom.cli.network.packages` |  | listOf package| [ pkgs.wget pkgs.curl pkgs.mtr pkgs.nmap pkgs.hping pkgs.iperf pkgs.mtr pkgs.tmux ] |
| `custom.cli.network.tmux.config_file` |  | nullOr path| null |
| `custom.cli.modern.bat.package` |  | package | pkgs.bat |
| `custom.cli.modern.bat.theme` |  | str | "Monokai Extended" |
| `custom.cli.modern.bat.extra.packages` |  | listOf package | [ pkgs.bat-extras.batdiff ] |
| `custom.ssh.enable` |  | bool | false |
| `custom.ssh.matchBlocks` |  | attrs | {} |
| `custom.nixify.enable` |  | bool | false |
| `custom.nixify.binary_file` |  | nullOr | null |
| `custom.nixify.config_file` |  | nullOr | null |
| `custom.aerospace.enable` |  | bool | false |
| `custom.aerospace.config_file` |  | nullOr path| null |
| `custom.aerospace.scratchpad_file` |  | nullOr path | null |
| `custom.fonts.nerdFonts.fonts` |  | listOf str | [ "FiraCode" "Hack" ] |
| `custom.dev.go.package` |  | package | pkgs.go |
| `custom.dev.go.extraPackages` |  | listOf package| [] |
| `custom.git.package` |  | package | pkgs.git |
| `custom.git.signingKey` |  | str | "~/.ssh/id_ed25519.pub" |
| `custom.git.extra.enable` |  | bool | config.custom.git.enable |
| `custom.git.extra.packages` |  | listOf package | [ pkgs.act pkgs.delta pkgs.gitleaks pkgs.colordiff ] |
| `custom.git.config.gitignore_global` |  | nullOr | null |
| `custom.git.config.username` |  | str | "User Name" |
| `custom.git.config.email` |  | str | "user@email.tld" |
| `custom.git.gh.enable` |  | bool | config.custom.git.enable |
| `custom.git.gh.package` |  | package | pkgs.gh |
| `custom.git.gh.config` |  | nullOr path| null |
| `custom.git.gh.settings` |  | attr | <https://github.com/mbovo/nix-configs/blob/51ad19f80176415dfc43fd10d279d68c09fa568d/modules/home-manager/git/git.nix#L69:L79> |
