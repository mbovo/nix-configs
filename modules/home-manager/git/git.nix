{ config, pkgs, lib, ... }@inputs:

{
  options = {
    custom.git.enable = lib.mkEnableOption "Enable custom git configuration";

    custom.git.package = lib.mkOption {
      default = pkgs.git;
      type = lib.types.package;
      description = "git package to install";
    };

    custom.git.extraConfig = {
      signingKey = lib.mkOption {
        default = "~/.ssh/id_ed25519.pub";
        type = lib.types.str;
        description = "gpg signing key";
      };
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
        pkgs.gitleaks
        pkgs.colordiff
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
      default = "User Name";
      type = lib.types.str;
      description = "git user name";
    };

    custom.git.config.email = lib.mkOption {
      default = "user@email.tld";
      type = lib.types.str;
      description = "git user email";
    };

    custom.git.gh.enable = lib.mkOption {
      default = config.custom.git.enable;
      type = lib.types.bool;
      description = "Enable gh package";
    };

    custom.git.gh.package = lib.mkOption {
      default = pkgs.gh;
      type = lib.types.package;
      description = "gh package to install";
    };

    custom.git.gh.settings = lib.mkOption {
      default =  {
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
      type = lib.types.attrs;
      description = "gh settings";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf config.custom.git.enable {
      home.packages = [ config.custom.git.package ];

      programs.git = {
            enable = true;
            package = config.custom.git.package;
            userName = config.custom.git.config.username;
            userEmail = config.custom.git.config.email;
            aliases = {
              root = "rev-parse --show-toplevel";
              oops = "commit --amend --no-edit";
              daje = "push --force-with-lease";
            };
            extraConfig = {
              user = {
                signingKey = config.custom.git.extraConfig.signingKey;
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
    })
    (lib.mkIf config.custom.git.gh.enable {
      programs = {
        gh = {
          enable = config.custom.git.gh.enable;
          package = config.custom.git.gh.package;
          settings = config.custom.git.gh.settings;
        };
      };

    })
    (lib.mkIf (config.custom.git.config.gitignore_global != null) {
      home.file = {
        ".gitignore_global".source = config.custom.git.config.gitignore_global;
      };
    })
  ];
}