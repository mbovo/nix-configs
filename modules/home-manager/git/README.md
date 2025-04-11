# git Module Options

| Option | Description | Type | Default |
|--------|-------------|------|---------|
| `custom.git.package` |  | package | pkgs.git |
| `signingKey` |  | str | "~/.ssh/id_ed25519.pub" |
| `custom.git.extra.enable` |  | bool | config.custom.git.enable |
| `custom.git.extra.packages` |  | listOf package | [ pkgs.act pkgs.delta pkgs.gitleaks pkgs.colordiff ] |
| `custom.git.config.gitignore_global` |  | nullOr | null |
| `custom.git.config.username` |  | str | "User Name" |
| `custom.git.config.email` |  | str | "user@email.tld" |
| `custom.git.gh.enable` |  | bool | config.custom.git.enable |
| `custom.git.gh.package` |  | package | pkgs.gh |
| `custom.git.gh.config` |  | nullOr path| null |
| `custom.git.gh.settings` |  | attr | <https://github.com/mbovo/nix-configs/blob/51ad19f80176415dfc43fd10d279d68c09fa568d/modules/home-manager/git/git.nix#L69> |
