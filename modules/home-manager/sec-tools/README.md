# default Module Options

| Option | Description | Type | Default |
|--------|-------------|------|---------|
| `custom.secTools.packages` |  | listOf | [
        # Certificates & Encryption & Secrets
        pkgs.cfssl
        pkgs.age
        pkgs.gnupg24
        pkgs.sops
      ] |
| `custom.secTools.extra.packages` |  | listOf | [
        pkgs.bitwarden-cli
      ] |
