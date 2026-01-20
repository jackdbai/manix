{ config, home-manager,lib, pkgs, user, userHome, ... }:

{
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initContent = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    shellAliases = {
      rebuild = "sudo darwin-rebuild switch --flake ~/Documents/GitHub/manix#main";
    };
  };
}