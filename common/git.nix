{ config, pkgs, homeDirectory, priv-config, ... }@inputs:

{
  home = {
    packages =  with pkgs; [
      act
      delta
      gh
      git
      gitleaks
    ];

    file = {
      ".gitignore_global".source = "${priv-config}/common/dotfiles/.gitignore_global";
    };
  };

  sops = {
    secrets = { 
      gh = {
        format = "binary";
        sopsFile = "${priv-config}/common/dotfiles/config/gh/hosts.yml.sops";
        path = "${homeDirectory}/.config/gh/hosts.yml";
      };
    };
  };

  programs = {
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        pager = ""; # use env vars
        editor = ""; # use env vars
        aliases = {
          co = "!id=\"$(gh pr list -L100 | fzf | cut -f1)\"; [ -n \"$id\" ] && gh pr checkout \"$id\"";
          pl = "pr list";
          pv = "pr view";
          pw = "pr view --web";
        };
      };
    };

    git = {
      enable = true;
      userName = "Manuel Bovo";
      userEmail = "manuel.bovo@gmail.com";
      aliases = {
        root = "rev-parse --show-toplevel";
        oops = "commit --amend --no-edit";
        daje = "push --force-with-lease";
      };
      extraConfig = {
        user = {
          signingKey = "~/.ssh/id_ed25519.pub";
        };
        commit = {
          gpgSign = "true";
        };
        gpg = {
          format = "ssh";
        };
        core = {
          pager = "";
          excludesfile = "${homeDirectory}/.gitignore_global";
          quotepath = false;
          commitGraph = true;
        };
        help = {
          autocorrect = 20;
        };
        push = {
          autoSetupRemote = "true";
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = "false";
        };
        gc = {
          writeCommitGraph = "true";
        };
        color = {
          ui = "true";
          status = {
            changed = "yellow normal bold";
            untracked = "cyan";
            added = "green";
            modified = "red blink";
            header = "white normal";
          };
          pull = {
            changed = "yellow normal bold";
            untracked = "cyan";
            added = "green";
            modified = "red blink";
            header = "white normal";
          };
          push = {
            changed = "yellow normal bold";
            untracked = "cyan";
            added = "green";
            modified = "red blink";
            header = "white normal";
          };
        };
      };
    };
  };
}