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
      "ffmpeg"
      "gemini-cli"
      "gh"
      "hugo"
      "lame"
      "mas"
      "nmap"
      "node"
      "npm"
      "node@22"
      # "proxmark3"
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
      "brave-browser"
      "browseros"
      "burp-suite"
      # "clawdbot"
      "cold-turkey-blocker"
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
      "ScreenZen- Screen Time Control" = 1541027222;
    };
  };
}
