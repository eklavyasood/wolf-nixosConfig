# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
  cfg = config.services.seatd;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # zsh
  environment.shells = with pkgs; [ bash zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # load nvidia drivers for xorg and wayland
  # services.xserver.videoDrivers = [ "nvidia" ];

  environment.sessionVariables = {
  # Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    # Opengl
    opengl.enable = true;
  
    nvidia = {
      # Most Wayland compositors need this
      modesetting.enable = true;
  
      open = false;
  
      nvidiaSettings = true;
  
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
  };

  # systemd services
  systemd.services = {
   swapEscape = {
     enable = true;
     unitConfig = {
       Description = "Autostart Kanata as superuser";
     };
     script = ''
       /run/current-system/sw/bin/kanata -c /home/wolf/.config/kanata/kanata.kbd
     '';
     # serviceConfig = {
     #   ExecStart=/home/wolf/.config/systemd/swapEscape.sh;
     # };
     wantedBy = [ "multi-user.target" ];
   };

   seatd = {
      enable = true;
      unitConfig = {
        Description = "Seatd";
        Documentation = [ "man:seatd(1)" ];
      };

      wantedBy = [ "multi-user.target" ];
      restartIfChanged = false;

      serviceConfig = {
        Type = "simple";
        NotifyAccess = "all";
        SyslogIdentifier = "seatd";
        ExecStart = "${pkgs.sdnotify-wrapper}/bin/sdnotify-wrapper ${pkgs.seatd.bin}/bin/seatd -n 1 -u ${cfg.user} -g ${cfg.group} -l ${cfg.logLevel}";
        RestartSec = 1;
        Restart = "always";
      };
    };
  };

  networking.hostName = "wolfNix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable Desktop Environments.
  # services.displayManager.sddm.enable = true;
  # services.xserver.displayManager.lightdm.enable = false;
  # services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.pantheon.enable = false;

# Display Managers, Desktop Managers, Window Managers
  services = {
    displayManager = {
      sddm = {
        enable = true;
      };
    };

    desktopManager = {
      plasma6 = {
        enable = true;
      };
    };

    xserver = {
      enable = true;

      displayManager = {
        lightdm = {
          enable = false;
        };
      };

      desktopManager = {
        pantheon = {
          enable = false;
        };
      };

      windowManager = {
        dwm = {
          enable = true;
          package = pkgs.dwm.overrideAttrs {
            src = /home/wolf/.config/dwm;
          };
        };

        bspwm = {
          enable = true;
        };
      };
    };
  };

  # Enable Hyprland
  programs.hyprland.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts.packages = with pkgs; [
    nerdfonts
    fira
    fira-code
    fira-code-symbols
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.groups.seat = {
    name = "seat";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wolf = {
    isNormalUser = true;
    description = "Eklavya Sood";
    extraGroups = [ "networkmanager" "wheel" "seat" "video"];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wlroots
    seatd
    sdnotify-wrapper
    hyprland
    rofi-wayland
    waybar
    ly
    gcc
    unzip
    kanata
    git
    vim
    neovim
    wget
    lutris
    wl-clipboard
    inputs.zen-browser.packages."${system}".default
    gnumake
    feh
    picom
    sxhkd
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
