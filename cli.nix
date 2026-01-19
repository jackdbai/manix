{ nixpkgs-go, nixpkgs-odin, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gemini-cli
    wget
  ];
}
