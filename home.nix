{ config, pkgs, user, userHome, ... }:
{
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      rebuild = "sudo darwin-rebuild switch --flake ~/Documents/GitHub/manix#main";
    };
  };
}