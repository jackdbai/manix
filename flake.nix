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
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:Homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:Homebrew/homebrew-cask";
      flake = false;
    };
    proxmark = {
      url = "github:proxmark/homebrew-proxmark3";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nix-homebrew, homebrew-core, homebrew-cask, proxmark }:
  let
    user = "jack";
    userHome = "/Users/${user}";
    configuration = { pkgs, ... }: {
      nix.settings.experimental-features = "nix-command flakes";
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs = {
        hostPlatform = "aarch64-darwin";
        config.allowUnfree = true;
      };
      system.primaryUser = "${user}";
      system.defaults = {
        CustomUserPreferences = {
          "com.apple.Siri" = {
            "UAProfileCheckingStatus" = 0;
            "siriEnabled" = 0;
          };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          "com.apple.desktopservices" = {
            DsDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
        };
        dock = {
          minimize-to-application = true;
          mru-spaces = false;
          orientation = "left";
          persistent-apps = [
            "/Users/${user}/Applications/Chrome Apps.localized/Google Gemini.app/"
            "/Applications/Antigravity.app/"
            "/Users/${user}/Applications/Chrome Apps.localized/Google Calendar.app/"
            "/Applications/Google Chrome.app/"
            "/Applications/GitHub Desktop.app/"
            "/Users/${user}/Applications/Chrome Apps.localized/Gmail.app/"
            "/Users/${user}/Applications/Chrome Apps.localized/Google Keep.app/"
            "/Users/${user}/Applications/Chrome Apps.localized/Messages.app/"
            "/Applications/Obsidian.app/"
            "/Applications/Proton Mail.app/"
            "/Users/${user}/Applications/Chrome Apps.localized/Google Tasks.app/"
            "/System/Applications/Utilities/Terminal.app/"
          ];
          show-recents = false;
          wvous-br-corner = 1;
        };
        finder = {
          FXEnableExtensionChangeWarning = false;
          FXPreferredViewStyle = "Nlsv";
          NewWindowTarget = "Home";
          _FXShowPosixPathInTitle = true;
          _FXSortFoldersFirst = true;
          _FXSortFoldersFirstOnDesktop = true;
          };
      };

      users.users.${user}.home = "${userHome}";

      system.activationScripts.extraActivation.text = ''
        softwareupdate --install-rosetta --agree-to-license
      '';
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      environment.systemPackages = with pkgs; [
        chirp
      ];
    };
  in
  {
    darwinConfigurations."main" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        ./brew.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit user userHome; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import ./home.nix;
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "${user}";
            autoMigrate = true;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "proxmark/homebrew-proxmark3" = proxmark;
            };
            mutableTaps = false;
          };
        }
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
      ];
    };
  };
}
