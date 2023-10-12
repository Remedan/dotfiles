{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.polybar;
  colorschemes = {
    "gruvbox-dark" = {
      background = "#282828";
      foreground = "#ebdbb2";
      foreground-alt = "\${colors.color7}";
      primary = "\${colors.color3}";
      alert = "\${colors.color1}";

      color0 = "#282828";
      color1 = "#cc241d";
      color2 = "#98971a";
      color3 = "#d79921";
      color4 = "#458588";
      color5 = "#b16286";
      color6 = "#689d6a";
      color7 = "#a89984";
    };
    "selenized-dark" = {
      background = "#103c48";
      foreground = "#adbcbc";
      foreground-alt = "\${colors.color7}";
      primary = "\${colors.color3}";
      alert = "\${colors.color1}";

      color0 = "#174956";
      color1 = "#fa5750";
      color2 = "#75b938";
      color3 = "#dbb32d";
      color4 = "#4695f7";
      color5 = "#f275be";
      color6 = "#41c7b9";
      color7 = "#72898f";
    };
    "dracula" = {
      background = "#282A36";
      foreground = "#F8F8F2";
      foreground-alt = "\${colors.color7}";
      primary = "\${colors.color3}";
      alert = "\${colors.color1}";

      color0 = "#000000";
      color1 = "#FF5555";
      color2 = "#50FA7B";
      color3 = "#F1FA8C";
      color4 = "#BD93F9";
      color5 = "#FF79C6";
      color6 = "#8BE9FD";
      color7 = "#BFBFBF";
    };
  };
in
{
  options.user-modules.polybar = {
    enable = mkEnableOption "Polybar";
    bar0Override = mkOption {
      type = with types; attrsOf anything;
      default = { };
    };
    bar1Override = mkOption {
      type = with types; attrsOf anything;
      default = { };
    };
  };
  config = mkIf cfg.enable {
    services.polybar = {
      enable = true;
      package = pkgs.polybarFull;
      script = "polybar b0 &";
      settings = {
        "colors" = colorschemes.${config.user-modules.common.colorscheme};
        "settings" = {
          screenchange-reload = true;
        };
        "global/wm" = {
          margin-top = 5;
          margin-bottom = 5;
        };
        "bar/b0" = {
          fixed-center = true;

          width = "100%";
          height = 27;

          background = "\${colors.background}";
          foreground = "\${colors.foreground}";

          line-size = 3;
          line-color = "\${colors.color1}";

          padding-left = 0;
          padding-right = 2;
          module-margin = 1;

          font = [
            "Symbols\ Nerd\ Font:10;2"
            "Open Sans:pixelsize=11;2"
            "Source\ Han\ Sans:pixelsize=10;2"
          ];

          modules-left = "i3 playerctl mpd pulseaudio";
          modules-center = "xwindow";
          modules-right = "filesystem xkeyboard cpu memory date powermenu";

          tray-position = "right";
          tray-padding = 2;

          enable-ipc = true;

          scroll-up = "i3wm-wsprev";
          scroll-down = "i3wm-wsnext";

          cursor-click = "pointer";
        } // cfg.bar0Override;
        "bar/b1" = {
          "inherit" = "bar/b0";
          tray-position = "";
        } // cfg.bar1Override;
        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title:0:40:...%";
        };
        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          blacklist = [ "num lock" ];

          format-prefix = " ";
          format-prefix-foreground = "\${colors.color1}";

          label-layout = "%layout%";

          label-indicator-padding = 2;
          label-indicator-margin = 1;
          label-indicator-background = "\${colors.alert}";
        };
        "module/filesystem" = {
          type = "internal/fs";
          interval = 25;

          mount = [ "/" ];

          label-mounted = "%{F#0a81f5}%mountpoint%%{F-}: %percentage_used%%";
          label-unmounted = "%mountpoint% not mounted";
          label-unmounted-foreground = "\${colors.foreground-alt}";
        };
        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = true;
          wrapping-scroll = false;
          enable-scroll = false;

          # Only show workspaces on the same output as the bar
          pin-workspaces = true;

          label-mode-padding = 2;
          label-mode-foreground = "\${colors.background}";
          label-mode-background = "\${colors.primary}";

          # focused = Active workspace on focused monitor
          label-focused = "%name%";
          label-focused-underline = "\${colors.primary}";
          label-focused-padding = 2;

          # unfocused = Inactive workspace on any monitor
          label-unfocused = "%name%";
          label-unfocused-padding = 2;

          # visible = Active workspace on unfocused monitor
          label-visible = "%name%";
          label-visible-underline = "\${self.label-focused-underline}";
          label-visible-padding = "\${self.label-focused-padding}";

          # urgent = Workspace with urgency hint set
          label-urgent = "%name%";
          label-urgent-background = "\${colors.alert}";
          label-urgent-padding = 2;
        };
        "module/mpd" = {
          type = "internal/mpd";
          format-online = "<label-song>  <icon-prev> <icon-stop> <toggle> <icon-next>";
          format-stopped = "";

          icon-prev = "";
          icon-stop = "";
          icon-play = "";
          icon-pause = "";
          icon-next = "";

          label-song-maxlen = 40;
          label-song-ellipsis = true;
        };
        "module/xbacklight" = {
          type = "internal/xbacklight";

          format = "<label>";
          label = " %percentage%%";
        };
        "module/backlight" = {
          type = "internal/backlight";

          card = "intel_backlight";

          format = "<label>";
          label = " %percentage%%";
        };
        "module/playerctl" = {
          type = "custom/script";
          exec = "playerctl --follow metadata --format '{{emoji(status)}} {{ artist }} - {{ title }}'";
          tail = true;
          click-left = "playerctl previous";
          click-right = "playerctl next";
          click-middle = "playerctl play-pause";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = " ";
          format-prefix-foreground = "\${colors.color2}";
          label = "%percentage:2%%";
        };
        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format-prefix = " ";
          format-prefix-foreground = "\${colors.color3}";
          label = "%percentage_used%%";
        };
        "module/eth" = {
          type = "internal/network";
          interface = "eno1";
          interval = 3.0;

          format-connected-underline = "#55aa55";
          format-connected-prefix = " ";
          format-connected-prefix-foreground = "\${colors.foreground}";
          label-connected = "%local_ip%";

          format-disconnected = "";
        };
        "module/date" = {
          type = "internal/date";
          interval = 5;

          date = "%a, %d %b %Y";
          date-alt = "%Y-%m-%d";
          time = "%H:%M";
          time-alt = "%H:%M:%S";

          format-prefix = " ";
          format-prefix-foreground = "\${colors.color4}";

          label = "%date% - %time%";
        };
        "module/pulseaudio" = {
          type = "internal/pulseaudio";

          format-volume = "<label-volume> <bar-volume>";
          label-volume = "";
          label-volume-foreground = "\${root.foreground}";

          format-muted-prefix = " ";
          format-muted-foreground = "\${root.foreground}";
          label-muted = "sound muted";

          bar-volume-width = 10;
          bar-volume-foreground = [
            "#55aa55"
            "#55aa55"
            "#55aa55"
            "#55aa55"
            "#55aa55"
            "#f5a70a"
            "#ff5555"
          ];
          bar-volume-gradient = false;
          bar-volume-indicator = "|";
          bar-volume-fill = "─";
          bar-volume-empty = "─";
          bar-volume-empty-foreground = "\${colors.foreground-alt}";
        };
        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "ACAD";
          full-at = 98;

          format-charging = "<label-charging>";
          label-charging = " %percentage%%";

          format-discharging = "<ramp-capacity> <label-discharging>";

          format-full-prefix = " ";
          format-full-prefix-foreground = "\${colors.color6}";

          ramp-capacity = [ "" "" "" "" "" ];
          ramp-capacity-foreground = "\${colors.color6}";
        };
        "module/powermenu" = {
          type = "custom/menu";

          expand-right = true;

          format-spacing = 1;

          label-open = "";
          label-open-foreground = "\${colors.color1}";
          label-close = " cancel";
          label-close-foreground = "\${colors.color1}";
          label-separator = "|";
          label-separator-foreground = "\${colors.foreground-alt}";

          menu-0-0 = "log out";
          menu-0-0-exec = "i3-msg exit";
          menu-0-1 = "reboot";
          menu-0-1-exec = "systemctl reboot";
          menu-0-2 = "power off";
          menu-0-2-exec = "systemctl poweroff";
        };
      };
    };
  };
}
