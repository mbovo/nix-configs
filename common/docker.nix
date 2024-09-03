{config, pkgs, homeDirectory, sops, priv-config,...}@inputs:

{
  home = {
    packages = with pkgs; [
      dive
      docker
      docker-buildx
      docker-compose
    ];

    file = {
      ".docker/daemon.json".source = "${priv-config}/common/dotfiles/docker/daemon.json";
    };
  };

  sops = {
    secrets = { 
      dockerconfig = {
        format = "binary";
        sopsFile = "${priv-config}/common/dotfiles/docker/config.json.sops";
        path = "${homeDirectory}/.docker/config.json";
      };
    };
  };

}