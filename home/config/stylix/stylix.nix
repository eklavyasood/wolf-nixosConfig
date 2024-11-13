{pkgs, config, userSettings, ...}:
let
  imagePath = /home/${userSettings.username}/.dotfiles/themes/bleak-cabin/wallpaper.png;
in
{
  stylix = {
    enable = true;

    image = imagePath;

    polarity = "dark";

    opacity = {
      terminal = 0.8;
    };

    targets = {
      kitty = { enable = true; };

      rofi = {
        enable = true;
        # fontSize = 14; # this option doesn't exist yet
      };

      nixvim = {
        enable = true;
        # plugin = "base16-nvim";
      };

      # spicetify = { enable = true; };

      emacs = { enable = true; };
      
    };

    fonts = {
      serif = {
        package = pkgs.fira;
        name = "Fira Serif";
      };

      sansSerif = {
        package = pkgs.fira-sans;
        name = "Fira Sans Serif";
      };

      monospace = {
        package = pkgs.fira-code;
        name = "Fira Monospace";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 12;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };
  };
}