{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.waybar;
in
{
  options.user-modules.waybar = {
    enable = mkEnableOption "Waybar";
  };
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          modules-left = [
            "sway/workspaces"
            "hyprland/workspaces"
            "pulseaudio"
            "sway/mode"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "hyprland/language"
            "disk"
            "cpu"
            "memory"
            "backlight"
            "battery"
            "tray"
          ];
        };
      };
    };
  };
}
