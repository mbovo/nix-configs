{ config, pkgs, ...}:
{
  home = {
    packages = with pkgs; [
      lima
      colima
      qemu
    ] ;
  };
}