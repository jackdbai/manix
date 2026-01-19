{
  description = "Jack's Manic Mac Nix";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    user = "jack";
    userHome = "/Users/${user}";
    configuration = { pkgs, ... }: {
      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs = {
        hostPlatform = "aarch64-darwin";
        config.allowUnfree = true;
      };

      # Set primary user
      system.primaryUser = "${user}";

      # Sane System Defaults
      system.defaults = {
        CustomUserPreferences = {
          # Disable Siri
          "com.apple.Siri" = {
            "UAProfileCheckingStatus" = 0;
            "siriEnabled" = 0;
          };
          # Disable personalized ads
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          "com.apple.desktopservices" = {
            DsDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
        };
      };

      users.users.${user}.home = "${userHome}";

      # Ensure Rosetta 2 is installed on Apple Silicon
      # Then enable x86-64 emulation
      system.activationScripts.extraActivation.text = ''
        softwareupdate --install-rosetta --agree-to-license
      '';
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#main
    darwinConfigurations."main" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        ./brew.nix
        ./cli.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit user userHome; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./home.nix;
        }
      ];
    };
  };
}
