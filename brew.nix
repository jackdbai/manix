{ ... }: {
  homebrew = {
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    enable = true;
    brews = [ # CLI Applications
      "docker"
      "docker-compose"
      "gemini-cli"
      "gh"
      "hugo"
      "lame"
      "mas"
      "nmap"
      "node"
      "npm"
      "proxmark3"
      "ripgrep"
      "speedtest-cli"
      "unbound"
      "xz"
      "yt-dlp"
      "wget"
    ];
    casks = [ # GUI Applications
      "1password"
      "android-file-transfer"
      "android-platform-tools"
      "android-studio"
      "antigravity"
      "audacity"
      "browseros"
      "burp-suite"
      "chatgpt-atlas"
      "cold-turkey-blocker"
      "comet"
      "discord"
      "docker-desktop"
      "elgato-stream-deck"
      "flutter"
      "freecad"
      "garmin-express"
      "gimp"
      "github"
      "google-chrome"
      "google-drive"
      "kaleidoscope"
      "lm-studio"
      "localsend"
      "mactex"
      "minecraft"
      "musicbrainz-picard"
      "obsidian"
      "orcaslicer"
      "postman"
      "proton-mail"
      "raindropio"
      "rectangle"
      "signal"
      "stats"
      "steam"
      "sublime-text"
      "tailscale-app"
      "transmission"
      "vlc"
      "vnc-viewer"
      "wireshark-app"
    ];
    masApps = { # Mac App Store Applications
      # "Microsoft Remote Desktop" = 1295203466;
      # "Slack for Desktop" = 803453959;
      # Xcode = 497799835;
    };
  };
}
