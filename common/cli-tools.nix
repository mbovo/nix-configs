{ config, pkgs, pkgs-unstable, priv-config, ...}:
{
  home = {
    packages = with pkgs; [

      #wezterm # installed with brew since it's at system level
      bash
      nvd
      nix-diff

      # GNU tools
      colordiff
      direnv
      nix-direnv
      hping
      htop
      iperf
      less
      mtr
      tmux

      # Modern Tools
      asciinema
      bat
      # devbox pinned to unstable
      eza
      fd
      fzf
      glow
      go-task
      jq
      neovim
      ripgrep
      yazi
      yq
      nil
      nix-output-monitor
    ] ++ (with pkgs.bat-extras; [ batdiff ])
    ++ 
    [ 
      pkgs-unstable.devbox
    ];

    file = {
      ".tmux.conf".source = "${priv-config}/common/dotfiles/.tmux.conf";
      ".wezterm.lua".source = "${priv-config}/common/dotfiles/.wezterm.lua";
      ".config/direnv/direnv.toml".source = "${priv-config}/common/dotfiles/config/direnv/direnv.toml";
    };

    sessionVariables = {
        EDITOR = "nvim";
    };
  };

  programs = {
    bat = {
      enable = true;  # it will install the bat package too
      config = {
        theme = "Monokai Extended";
      };
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        log = {
          enabled = false;
        };
        manager = {
          show_hidden = true;
          sort_by = "modified";
          sort_dir_first = true;
          sort_reverse = true;
        };
      };
    };
  };
}
