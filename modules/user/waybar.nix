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

      style = ''
        @define-color color0 #282828;
        @define-color color1 #cc241d;
        @define-color color2 #98971a;
        @define-color color3 #d79921;
        @define-color color4 #458588;
        @define-color color5 #b16286;
        @define-color color6 #689d6a;
        @define-color color7 #a89984;
        @define-color foreground #ebdbb2;
        @define-color foreground-alt @color7;
        @define-color background #282828;
        @define-color primary @color3;
        @define-color alert @color1;

        * {
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
            font-size: 13px;
        }

        window#waybar {
            background-color: @background;
            color: @foreground;
            transition-property: background-color;
            transition-duration: .5s;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        button {
            border-radius: 0;
        }

        #workspaces button {
            padding: 0 5px;
            color: @foreground;
            background-color: transparent;
        }

        #workspaces button:hover {
            background: rgba(0, 0, 0, 0.5);
        }

        #workspaces button.focused {
            color: @background;
            background-color: @primary;
        }

        #workspaces button.urgent {
            background-color: @alert;
        }

        #mode {
            color: @background;
            background-color: @primary;
        }

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #temperature,
        #backlight,
        #network,
        #pulseaudio,
        #wireplumber,
        #custom-media,
        #tray,
        #mode,
        #language,
        #idle_inhibitor,
        #scratchpad,
        #power-profiles-daemon,
        #mpd {
            padding: 0 10px;
        }

        #pulseaudio {
          color: @color4;
        }

        #battery {
          color: @color6;
        }

        #cpu {
          color: @color2;
        }

        #disk {
          color: @foreground-alt;
        }

        #memory {
          color: @color3;
        }

        #mpris {
          color: @foreground-alt;
        }

        #language {
          color: @color1;
        }

        #window,
        #workspaces {
            margin: 0 4px;
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
        }
      '';

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
            format-paused = "{status_icon} {artist} - {title}";
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
            format = "{:%a, %d %b %Y %R}";
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

          "sway/language" = {
            format = "{}";
            on-click = "swaymsg input type:keyboard xkb_switch_layout next";
          };

          disk = {
            format = "/ {percentage_used}%";
            path = "/";
          };

          cpu = {
            format = "  {}%";
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
            format-icons = [ "" "" "" "" "" ];
          };

          tray = {
            spacing = 5;
          };
        };
      };
    };
  };
}
