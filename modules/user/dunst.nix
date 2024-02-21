{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.dunst;
in
{
  options.user-modules.dunst = {
    enable = mkEnableOption "Dunst";
  };
  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "keyboard";
          width = "(100, 500)";
          offset = "15x40";
          notification_limit = 0;
          frame_color = "#8EC07C";
          font = "Open Sans 12";
          show_indicators = false;
          icon_path = "/usr/share/icons/Adwaita/16x16/status/:/usr/share/icons/Adwaita/16x16/devices/:/usr/share/icons/Adwaita/16x16/legacy/";
        };
        urgency_log = {
          background = "#191311";
          foreground = "#3B7C87";
          frame_color = "#3B7C87";
        };
        urgency_normal = {
          background = "#191311";
          foreground = "#5B8234";
          frame_color = "#5B8234";
        };
        urgency_critical = {
          background = "#191311";
          foreground = "#B7472A";
          frame_color = "#B7472A";
        };
      };
    };
  };
}
