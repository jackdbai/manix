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
      adblist = "adb shell pm list packages";
      adblistu = "diff <(adb shell pm list packages) <(adb shell pm list packages -u)";
      adbreinst = "adb shell cmd package install-existing";
      adbuninst = "adb shell pm uninstall --user 0";
      adbkuninst = "adb shell pm uninstall -k --user 0";
      adbplaydisable = "adb shell pm disable-user --user 0 com.android.vending";
      adbplayenable = "adb shell pm enable-user --user 0 com.android.vending";
      cleanup = "sudo nix-collect-garbage -d";
      rebuild = "sudo darwin-rebuild switch --flake ~/Documents/GitHub/manix#main";
      update = "sudo nix flake update --flake ~/Documents/GitHub/manix";
      ytdl = "yt-dlp -t mp4";
      ytdl2 = "yt-dlp -f bestvideo+bestaudio --merge-output-format mp4";
    };
  };
}