# aws Module Options

| Option | Description | Type | Default |
|--------|-------------|------|---------|
| `custom.cloudProviders.aws.package` |  | package | pkgs.awscli2 |
| `custom.cloudProviders.aws.extraPackages` |  | listOf package | [ pkgs.eksctl pkgs.steampipe ] |
| `custom.cloudProviders.aws.extraConfig` |  | nullOr path | null |
