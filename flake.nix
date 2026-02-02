{
  description = "Jack's Manic Mac Nix";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    homebrew-cask = {
      url = "github:Homebrew/homebrew-cask";
      flake = false;
    };
    hosts.url = "github:StevenBlack/hosts";
    proxmark = {
      url = "github:proxmark/homebrew-proxmark3";
      flake = false;
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
    nix-openclaw.url = "github:openclaw/nix-openclaw";
  };

  outputs = inputs@{ self, home-manager, homebrew-cask, homebrew-core, hosts, nix-darwin, nix-homebrew, nix-openclaw, nixpkgs, proxmark }:
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
        CustomUserPreferences = { # Custom user preferences
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
        dock = { # Custom dock settings
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
            "/Users/${user}/Applications/Chrome Apps.localized/GroupMe.app/"
            "/Users/${user}/Applications/Chrome Apps.localized/Messages.app/"
            "/System/Applications/Messages.app"
            "/Applications/Obsidian.app/"
            "/Applications/Proton Mail.app/"
            "/Users/${user}/Applications/Chrome Apps.localized/Google Tasks.app/"
            "/System/Applications/Utilities/Terminal.app/"
          ];
          show-recents = false;
          wvous-br-corner = 1;
        };
        finder = { # Custom finder settings
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

      environment.systemPackages = with pkgs; [ # Install applications that are not available through Homebrew
        chirp
      ];
    };
  in
  {
    darwinConfigurations."main" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        ./brew.nix
        # nix-openclaw.homeManagerModules.default
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
