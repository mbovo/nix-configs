{ config, pkgs, username, homeDirectory, sops, lib, ... }@inputs:
{

  custom.k8s.enable = true;
  custom.k8s.extra.enable = true;
  custom.k8s.extra.clusterctl.enable = true;
  custom.k8s.extra.kyverno.enable = true;
  custom.k8s.extra.fluxcd.enable = true;
  custom.docker.enable = true;
  custom.docker.config.daemon = "${inputs.priv-config}/common/dotfiles/docker/daemon.json";
  custom.docker.config.file = "${inputs.priv-config}/common/dotfiles/docker/config.json.sops";

  custom.fonts.nerdFonts.enable = true;  

  custom.shells.zsh.enable = true;
  custom.shells.zsh.extra.files = {
      ".zshrc" = ../../config/dotfiles/zshrc;
      ".zsh_alias" = ../../config/dotfiles/zsh_alias;
      ".zsh_funx" = ../../config/dotfiles/zsh_funx;
      ".p10k.zsh" = ../../config/dotfiles/p10k.zsh;
      ".config/atuin/config.toml" = ../../config/dotfiles/config/atuin/config.toml;
  };
  custom.shells.atuin.enable = true;
  custom.shells.atuin.key = "${inputs.priv-config}/common/dotfiles/local/share/atuin/atuin.key";
  custom.shells.atuin.config = ../../config/dotfiles/config/atuin/config.toml;

  custom.shells.wezterm.enable = false;
  custom.shells.wezterm.config_file = ../../config/dotfiles/wezterm.lua;

  custom.git.enable = true;
  custom.git.config.gitignore_global = ../../config/dotfiles/gitignore_global;
  custom.git.gh.config = "${inputs.priv-config}/common/dotfiles/config/gh/hosts.yml.sops";

  custom.ssh.enable = true;

  custom.dev.python.enable = true;
  custom.dev.python.package = inputs.pkgs-unstable.python3;
  custom.dev.python.extraPackages = with inputs.pkgs-unstable; [
    pipenv
    poetry
  ];
  custom.dev.go.enable = true;

  custom.secTools.enable = true;

  custom.cli.direnv.enable = true;
  custom.cli.editor.enable = true;
  custom.cli.gnu.enable = true;
  custom.cli.network.enable = true;
  custom.cli.network.tmux.config_file = ../../config/dotfiles/tmux.conf;
  custom.cli.nix-utils.enable = true;  
  

  custom.cli.modern.bat.enable = true;
  custom.cli.modern.yazi.enable = true;
  custom.cli.modern.eza.enable = true;
  custom.cli.modern.fd.enable = true;
  custom.cli.modern.ripgrep.enable = true;
  custom.cli.modern.jq.enable = true;
  custom.cli.modern.fzf.enable = true;
  custom.cli.modern.extra.enable = true;
  
  custom.cli.modern.extra.packages = (lib.lists.remove pkgs.devbox config.custom.cli.modern.extra.default_packages) ++ [ inputs.pkgs-unstable.devbox ];
}