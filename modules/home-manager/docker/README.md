# docker Module Options

| Option | Description | Type | Default |
|--------|-------------|------|---------|
| `custom.docker.package` |  | package | pkgs.docker |
| `custom.docker.darwin.packages` |  | listOf package | [pkgs.qemu pkgs.lima pkgs.colima] |
| `custom.docker.extra.enable` |  | bool | config.custom.docker.enable |
| `custom.docker.extra.packages` |  | listOf package | [pkgs.docker-compose pkgs.docker-buildx pkgs.dive] |
| `custom.docker.config.daemon` |  | nullOr path| null |
| `custom.docker.config.file` |  | nullOr path | null |
