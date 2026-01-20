{ ... }: {
  homebrew = {
    onActivation.autoUpdate = true;
    enable = true;
    brews = [ # CLI Applications
      "gemini-cli"
      "mas"
      "wget"
    ];
    casks = [ # GUI Applications
      "1password"
      "antigravity"
      "github"
      "google-chrome"
      "google-drive"
      "obsidian"
      "proton-mail"
      "rectangle"
    ];
    masApps = { # Mac App Store Applications
      # "Microsoft Remote Desktop" = 1295203466;
      # "Slack for Desktop" = 803453959;
      # Xcode = 497799835;
    };
  };
}
