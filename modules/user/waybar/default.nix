{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.waybar;
in
{
  options.user-modules.waybar = {
    enable = mkEnableOption "Waybar";
    windowManager = mkOption {
      type = types.enum [ "sway" "hyprland" ];
      default = "sway";
    };
  };
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      style = ./style.css;

      settings = {
        mainBar = {
          height = 20;
          layer = "top";

          modules-left = [
            "${cfg.windowManager}/workspaces"
            "pulseaudio"
            "mpris"
            "custom/weather"
          ] ++ optional (cfg.windowManager == "sway") "sway/mode"
          ++ optional (cfg.windowManager == "hyprland") "hyprland/submap";
          modules-center = [
            "clock"
            "custom/notification"
          ];
          modules-right = [
            "privacy"
            "${cfg.windowManager}/language"
            "disk"
            "cpu"
            "memory"
            "backlight"
            "battery"
            "idle_inhibitor"
            "tray"
          ];

          "sway/workspaces" = {
            enable-bar-scroll = true;
          };

          "hyprland/workspaces" = {
            on-scroll-up = "hyprctl dispatch workspace m-1";
            on-scroll-down = "hyprctl dispatch workspace m+1";
          };

          "custom/weather" = {
            exec = "echo \"{\\\"text\\\": \\\"$(curl -s 'https://wttr.in/?format=%c+%t')\\\",\\\"tooltip\\\": \\\"$(curl -s 'https://wttr.in/?format=%l:+%C,+%t+(Feel:+%f),+Rain:+%p,+Humidity:+%h,+Wind:+%w,+UV:+%u')\\\"}\"";
            return-type = "json";
            format = "{}";
            interval = 3600;
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
            format-alt-click = "click-right";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              mode-mon-col = 3;
              weeks-pos = "left";
              on-scroll = 1;
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                days = "<span color='#ecc6d9'><b>{}</b></span>";
                weeks = "<span color='#99ffdd'><b>W{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
                today = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
            };
            on-click = "swaync-client -t -sw";
            actions = {
              on-click-middle = "mode";
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

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
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
