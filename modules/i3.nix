{ lib, colorscheme, terminal, i3Override, i3Startup, ... }:

let
  # Mod is the Windows key
  mod = "Mod4";
  powerControlMode = "[l]ock log[o]ut [s]uspend [h]ibernate [r]eboot [p]oweroff";
  colorschemes = {
    "gruvbox-dark" = {
      focused = {
        border = "#676d3d";
        background = "#676d3d";
        text = "#ebdbb2";
        indicator = "#676d3d";
        childBorder = "#676d3d";
      };
      unfocused = {
        border = "#323232";
        background = "#323232";
        text = "#ebdbb2";
        indicator = "#323232";
        childBorder = "#323232";
      };
      focusedInactive = {
        border = "#323232";
        background = "#333333";
        text = "#ebdbb2";
        indicator = "#323232";
        childBorder = "#333333";
      };
      urgent = {
        border = "#383a3b";
        background = "#383a3b";
        text = "#ee0000";
        indicator = "#383a3b";
        childBorder = "#383a3b";
      };
    };
    "selenized-dark" = {
      focused = {
        border = "#75b938";
        background = "#75b938";
        text = "#184956";
        indicator = "#4695f7";
        childBorder = "#75b938";
      };
      unfocused = {
        border = "#184956";
        background = "#184956";
        text = "#adbcbc";
        indicator = "#72898f";
        childBorder = "#184956";
      };
      focusedInactive = {
        border = "#41c7b9";
        background = "#41c7b9";
        text = "#184956";
        indicator = "#af88eb";
        childBorder = "#41c7b9";
      };
      urgent = {
        border = "#dbb32d";
        background = "#dbb32d";
        text = "#184956";
        indicator = "#ed8649";
        childBorder = "#dbb32d";
      };
    };
    "dracula" = {
      background = "#F8F8F2";
      focused = {
        border = "#6272A4";
        background = "#6272A4";
        text = "#F8F8F2";
        indicator = "#6272A4";
        childBorder = "#6272A4";
      };
      unfocused = {
        border = "#282A36";
        background = "#282A36";
        text = "#BFBFBF";
        indicator = "#282A36";
        childBorder = "#282A36";
      };
      focusedInactive = {
        border = "#44475A";
        background = "#44475A";
        text = "#F8F8F2";
        indicator = "#44475A";
        childBorder = "#44475A";
      };
      urgent = {
        border = "#44475A";
        background = "#FF5555";
        text = "#F8F8F2";
        indicator = "#FF5555";
        childBorder = "#FF5555";
      };
      placeholder = {
        border = "#282A36";
        background = "#282A36";
        text = "#F8F8F2";
        indicator = "#282A36";
        childBorder = "#282A36";
      };
    };
  };
in
{
  home.file.".config/i3/lock.sh" = {
    source = ../dotfiles/config/i3/lock.sh;
    executable = true;
  };
  xsession.windowManager.i3 = lib.recursiveUpdate
    {
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
          commands = [
            {
              command = "floating enable";
              criteria = {
                title = "Origin";
              };
            }
          ];
        };

        gaps = {
          inner = 12;
          smartGaps = true;
          smartBorders = "on";
        };

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
            command = "picom -b";
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
            command = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
          }
          {
            command = "feh --bg-fill ~/Pictures/wallpaper.png || feh --bg-fill ~/Pictures/wallpaper.jpg || feh --bg-tile ~/Pictures/wallpaper-tile.png || feh --bg-tile ~/Pictures/wallpaper-tile.jpg || feh --bg-fill --no-xinerama ~/Pictures/wallpaper-wide.png || feh --bg-fill --no-xinerama ~/Pictures/wallpaper-wide.jpg";
          }
        ] ++ i3Startup;

        colors = colorschemes.${colorscheme};

        keybindings = lib.mkOptionDefault {
          # Start a terminal
          "${mod}+Return" = "exec " + terminal;

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
          "XF86AudioPlay" = "exec ~/.config/i3/player-control.sh toggle";
          "XF86AudioNext" = "exec ~/.config/i3/player-control.sh next";
          "XF86AudioPrev" = "exec ~/.config/i3/player-control.sh prev";
          "XF86AudioStop" = "exec ~/.config/i3/player-control.sh stop";

          # Sreen brightness controls (brightness up, brightness down)
          "XF86MonBrightnessUp" = "exec xbacklight -inc 5";
          "XF86MonBrightnessDown" = "exec xbacklight -dec 5";

          # Printscreen saves screenshot (with shift only focused window)
          "Print" = "exec scrot";
          "Shift+Print" = "exec scrot -u";
          "Ctrl+Print" = "exec scrot -s";

          # Autorandr
          "${mod}+t" = "exec autorandr --change --default mobile";

          # Applications
          "${mod}+i" = "exec firefox";
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
          l = "exec ~/.config/i3/lock.sh; mode default";
          o = "exec i3-msg exit; mode default";
          s = "exec systemctl suspend; mode default";
          h = "exec systemctl hibernate; mode default";
          r = "exec systemctl reboot; mode default";
          p = "exec systemctl poweroff; mode default";

          Escape = "mode default";
        };

        bars = [ ];
      };
    }
    i3Override;
}
