{ lib, terminal, ... }:

let
  # Mod is the Windows key
  mod = "Mod4";
  powerControlMode = "[l]ock log[o]ut [s]uspend [h]ibernate [r]eboot [p]oweroff";
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;

      fonts = {
        names = [ "Open Sans" ];
        size = 11.0;
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

        # Sreen brightness controls (brightness up, brightness down)
        "XF86MonBrightnessUp" = "exec xbacklight -inc 5";
        "XF86MonBrightnessDown" = "exec xbacklight -dec 5";

        # Printscreen saves screenshot (with shift only focused window)
        "Print" = "exec scrot";
        "Shift+Print" = "exec scrot -u";
        "Ctrl+Print" = "exec scrot -s";

        # Media keys
        "XF86AudioPlay" = "exec ~/.config/i3/player-control.sh toggle";
        "XF86AudioNext" = "exec ~/.config/i3/player-control.sh next";
        "XF86AudioPrev" = "exec ~/.config/i3/player-control.sh prev";
        "XF86AudioStop" = "exec ~/.config/i3/player-control.sh stop";

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
        l = "exec i3lock; mode default";
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
}
