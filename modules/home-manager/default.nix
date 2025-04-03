{
  # Default config
  defconfig       = import ./defconf.nix;
  
  # Modules
  cli-tools       = import ./cli-tools;
  cloud-providers = import ./cloud-providers;
  dev-tools       = import ./dev-tools;
  docker          = import ./docker;
  fonts           = import ./fonts;
  git             = import ./git;
  k8s             = import ./k8s;
  sec-tools       = import ./sec-tools;
  shells          = import ./shells;
  ssh             = import ./ssh;

}