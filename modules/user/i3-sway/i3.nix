{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.user-modules.i3;

  mod = "Mod4"; # Mod is the Windows key
  powerControlMode = "[l]ock log[o]ut [s]uspend [h]ibernate [r]eboot [p]oweroff";
in
{
  options.user-modules.i3 = {
    enable = mkEnableOption "i3";
    colorscheme = mkOption {
      type = types.str;
      default = config.user-modules.common.colorscheme;
    };
    appWorkspace = mkOption {
      type = with types; attrsOf (listOf (attrsOf anything));
      default = { };
    };
    workspaceOutput = mkOption {
      type = with types; listOf (attrsOf anything);
      default = [ ];
    };
    startup = mkOption {
      type = with types; listOf (attrsOf anything);
      default = [ ];
    };
  };
  config = mkIf cfg.enable {
    user-modules = {
      polybar.enable = mkDefault true;
      rofi.enable = mkDefault true;
      dunst.enable = mkDefault true;
      autorandr.enable = mkDefault true;
      picom.enable = mkDefault true;
    };
    home.packages = with pkgs; [
      scrot
      xautolock
    ];
    xdg.configFile."i3/i3-lock.sh" = {
      source = ./i3-lock.sh;
      executable = true;
    };
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = mod;

        fonts = {
          names = [ "Open Sans" ];
          size = 9.0;
        };

        window = {
          border = 2;
          titlebar = false;
        };

        gaps = {
          inner = 12;
          smartGaps = true;
          smartBorders = "on";
        };

        floating.criteria = [
          { title = "Origin"; }
        ];

        colors = import ./colors/${cfg.colorscheme}.nix;

        assigns = cfg.appWorkspace;

        workspaceOutputAssign = cfg.workspaceOutput;

        startup = [
          {
            command = "polybar b0";
            notification = false;
          }
          {
            command = "unclutter";
            notification = false;
          }
          {
            command = "nm-applet";
            notification = false;
          }
          {
            command = "udiskie --tray";
            notification = false;
          }
          {
            command = "1password --silent";
          }
          {
            command = "feh --bg-fill ~/Pictures/wallpaper.png || feh --bg-fill ~/Pictures/wallpaper.jpg || feh --bg-tile ~/Pictures/wallpaper-tile.png || feh --bg-tile ~/Pictures/wallpaper-tile.jpg || feh --bg-fill --no-xinerama ~/Pictures/wallpaper-wide.png || feh --bg-fill --no-xinerama ~/Pictures/wallpaper-wide.jpg";
          }
        ] ++ cfg.startup;

        keybindings = lib.mkOptionDefault {
          # Start a terminal
          "${mod}+Return" = "exec " + config.user-modules.common.terminal;

          # Open a program launcher
          "${mod}+d" = "exec rofi -show run";
          "${mod}+Shift+d" = "exec rofi -show run -run-command 'gksudo {cmd}'";

          # Move focus
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          # Move focused window
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          # Split horizontally
          "${mod}+b" = "split h";

          # Split vertically
          "${mod}+v" = "split v";

          # Change container layout
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          # Focus parent container
          "${mod}+a" = "focus parent";

          # Focus child container
          "${mod}+z" = "focus child";

          # Quick workspace switching
          "${mod}+comma" = "workspace prev";
          "${mod}+period" = "workspace next";

          # Quick workspace moving
          "${mod}+Shift+comma" = "move workspace to output right";
          "${mod}+Shift+period" = "move workspace to output left";

          # Gap control
          "${mod}+y" = "gaps inner current minus 6";
          "${mod}+u" = "gaps inner current plus 6";
          "${mod}+Shift+y" = "gaps outer current minus 6";
          "${mod}+Shift+u" = "gaps outer current plus 6";

          # Audio controls (volume up, volume down, toggle mute)
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";

          # Media keys
          "XF86AudioPlay" = "exec playerctl --ignore-player=firefox play-pause";
          "XF86AudioNext" = "exec playerctl --ignore-player=firefox next";
          "XF86AudioPrev" = "exec playerctl --ignore-player=firefox previous";
          "XF86AudioStop" = "exec playerctl --ignore-player=firefox stop";

          # Sreen brightness controls (brightness up, brightness down)
          "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
          "XF86MonBrightnessDown" = "exec  brightnessctl set 10%-";

          # Printscreen saves screenshot (with shift only focused window)
          "Print" = "exec scrot";
          "Shift+Print" = "exec scrot -u";
          "Ctrl+Print" = "exec scrot -s";

          # Autorandr
          "${mod}+t" = "exec autorandr --change --default mobile";
          "${mod}+Shift+t" = "exec autorandr mobile";

          # Emoji picker
          "${mod}+g" = "exec rofimoji";

          # Applications
          "${mod}+i" = "exec ${config.user-modules.common.browser}";
          "${mod}+o" = "exec emacsclient -c";
          "${mod}+p" = "exec obsidian";

          # Modes
          "${mod}+r" = "mode resize";
          "${mod}+n" = "mode ${powerControlMode}";
        };

        modes."resize" = {
          h = "resize shrink width  10 px or 10 ppt";
          j = "resize grow   height 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          l = "resize grow   width  10 px or 10 ppt";

          Left = "resize shrink width  10 px or 10 ppt";
          Down = "resize grow   height 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Right = "resize grow   width  10 px or 10 ppt";

          Escape = "mode default";
        };
        modes.${powerControlMode} = {
          l = "exec ~/.config/i3/i3-lock.sh; mode default";
          o = "exec i3-msg exit; mode default";
          s = "exec systemctl suspend; mode default";
          h = "exec systemctl hibernate; mode default";
          r = "exec systemctl reboot; mode default";
          p = "exec systemctl poweroff; mode default";

          Escape = "mode default";
        };

        bars = [ ];
      };
    };
  };
}
