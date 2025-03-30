{ config, pkgs, lib, ... }@inputs:

{
  options = {
    custom.git.enable = lib.mkEnableOption "Enable custom git configuration";

    custom.git.package = lib.mkOption {
      default = pkgs.git;
      type = lib.types.package;
      description = "git package to install";
    };

    custom.git.extra.enable = lib.mkOption {
      default = config.custom.git.enable;
      type = lib.types.bool;
      description = "Enable extra git packages";
    };

    custom.git.extra.packages = lib.mkOption {
      default = [
        pkgs.act
        pkgs.delta
        pkgs.gh
        pkgs.gitleaks
      ];
      type = lib.types.listOf lib.types.package;
      description = "list of git packages to install";
    };

    custom.git.config.gitignore_global = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "path to the gitignore_global file (if any)";
    };

    custom.git.config.username = lib.mkOption {
      default = "Manuel Bovo";
      type = lib.types.str;
      description = "git user name";
    };

    custom.git.config.email = lib.mkOption {
      default = "manuel.bovo@gmail.com";
      type = lib.types.str;
      description = "git user email";
    };

    custom.git.gh.config = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = "path to the gh config file (if any)";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.git.enable {
      home.packages = [ config.custom.git.package ];

      programs.git = {
            enable = true;
            userName = config.custom.git.config.username;
            userEmail = config.custom.git.config.email;
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
                excludesfile = "${inputs.homeDirectory}/.gitignore_global";
                quotepath = false;
                commitGraph = true;
              };
              help = {
                autocorrect = 20;
              };
              push = {
                autoSetupRemote = "true";
                followTags = "true";
              };
              pull = {
                rebase = "false";
              };
              fetch = {
                prune = "true";
                pruneTags = "true";
                all = "true";
              };
              rebase = {
                autoStash = "true";
                updateRefs = "true";
                autoSquash = "true";
              };
              init = {
                defaultBranch = "main";
              };
              tag = {
                sort = "version:refname";
              };
              branch = {
                sort = "-committerdate";
              };
              column = {
                ui = "auto";
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
    })
    (lib.mkIf config.custom.git.extra.enable {
      home.packages = config.custom.git.extra.packages;

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
      };

    })
    (lib.mkIf (config.custom.git.config.gitignore_global != null) {
      home.file = {
        ".gitignore_global".source = config.custom.git.config.gitignore_global;
      };
    })
    (lib.mkIf (config.custom.git.gh.config != null) {
      sops.secrets.gh = {
        format = "binary";
        sopsFile = config.custom.git.gh.config;
        path = "${inputs.homeDirectory}/.config/gh/hosts.yml";
      };
    })
  ];
}