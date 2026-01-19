{ ... }: {
  homebrew = {
    onActivation.autoUpdate = true;
    enable = true;
    casks = [
      "1password"
      "antigravity"
      "github"
      "google-chrome"
      "google-drive"
      "obsidian"
      "rectangle"
    ];
  };
}
