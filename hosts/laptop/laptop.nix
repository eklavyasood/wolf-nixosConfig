{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../stylix/laptop
    ../../system
    ../../modules/laptop
  ];

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    wpa_supplicant_gui
  ];
  
  programs.niri.enable = true;

  networking.hostName = "wolfNixLap";

  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = { 
        governor = "powersave";
        turbo = "never";
      };

      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
