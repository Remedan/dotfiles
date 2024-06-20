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
      systemd.enable = true;

      style = ./style.css;

      settings = {
        mainBar = {
          height = 20;
          layer = "top";

          modules-left = [
            "hyprland/workspaces"
            "pulseaudio"
            "mpris"
            "custom/weather"
            "hyprland/submap"
          ];
          modules-center = [
            "clock"
            "custom/notification"
          ];
          modules-right = [
            "privacy"
            "hyprland/language"
            "disk"
            "cpu"
            "memory"
            "backlight"
            "battery"
            "idle_inhibitor"
            "tray"
          ];

          "hyprland/workspaces" = {
            on-scroll-up = "hyprctl dispatch workspace m-1";
            on-scroll-down = "hyprctl dispatch workspace m+1";
          };

          "custom/weather" = {
            exec = "echo \"{\\\"text\\\": \\\"$(${pkgs.curl}/bin/curl -s 'https://wttr.in/?format=%c+%t')\\\",\\\"tooltip\\\": \\\"$(${pkgs.curl}/bin/curl -s 'https://wttr.in/?format=%l:+%C,+%t+(Feel:+%f),+Rain:+%p,+Humidity:+%h,+Wind:+%w,+UV:+%u')\\\"}\"";
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
            on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
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
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
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
            exec-if = "which ${pkgs.swaynotificationcenter}/bin/swaync-client";
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
            on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
            escape = true;
          };

          disk = {
            format = "/ {percentage_used}%";
            path = "/";
          };

          cpu = {
            format = "  {usage}%";
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
