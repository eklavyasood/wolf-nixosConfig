{ pkgs, ... }:
{
  imports = [
    ../../home/laptop
    ../../home/common
  ];

  home.packages = with pkgs; [
    brightnessctl
    android-studio
    speedtest-cli
    xwayland-satellite
  ];
}
