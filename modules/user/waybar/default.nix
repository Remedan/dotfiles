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

      style = ./style.css;

      settings = {
        mainBar = {
          modules-left = [
            "sway/workspaces"
            "pulseaudio"
            "mpris"
            "sway/mode"
          ];
          modules-center = [
            "clock"
            "custom/notification"
          ];
          modules-right = [
            "sway/language"
            "disk"
            "cpu"
            "memory"
            "backlight"
            "battery"
            "tray"
          ];

          "sway/workspaces" = {
            enable-bar-scroll = true;
          };

          pulseaudio = {
            format = "{icon}  {volume}%";
            format-bluetooth = "{icon}  {volume}%";
            format-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" ];
            };
            scroll-step = 5;
            on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          };

          mpris = {
            format = "{player_icon} {artist} - {title}";
            format-paused = "{status_icon} {artist} – {title}";
            player-icons = {
              default = "▶";
              mpv = "🎵";
            };
            status-icons = {
              paused = "⏸";
            };
            ignored-players = [ "firefox" ];
          };

          clock = {
            format = "{:%a, %d %b %Y – %R}";
            format-alt = "{:%Y-%m-%d %H:%M:%S}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              mode-mon-col = 3;
              weeks-pos = "left";
              on-scroll = 1;
              on-click-right = "mode";
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-click-forward = "tz_up";
              on-click-backward = "tz_down";
              on-scroll-up = "shift_down";
              on-scroll-down = "shift_up";
            };
          };

          "custom/notification" = {
            tooltip = false;
            format = "{icon}  {}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };

          "sway/language" = {
            format = "{}";
            on-click = "swaymsg input type:keyboard xkb_switch_layout next";
          };

          disk = {
            format = "/ {percentage_used}%";
            path = "/";
          };

          cpu = {
            format = "  {}%";
          };

          memory = {
            format = "  {}%";
          };

          backlight = {
            format = "  {}%";
            scroll-step = 5;
          };

          battery = {
            format = "{icon}   {capacity}%";
            format-icons = {
              default = [ "" "" "" "" "" ];
              charging = "";
              plugged = "";
            };
          };

          tray = {
            spacing = 5;
          };
        };
      };
    };
  };
}
