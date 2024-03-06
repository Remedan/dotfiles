{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.user-modules.sway;

  mod = "Mod4"; # Mod is the Windows key
  powerControlMode = "[l]ock log[o]ut [s]uspend [h]ibernate [r]eboot [p]oweroff";
in
{
  options.user-modules.sway = {
    enable = mkEnableOption "Sway";
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
    home.packages = with pkgs; [
      grim
      slurp
      wdisplays
      wofi
    ];
    user-modules = {
      waybar.enable = mkDefault true;
    };
    programs.swaylock.enable = true;
    wayland.windowManager.sway = {
      enable = true;
      swaynag.enable = true;
      systemd.enable = true;
      wrapperFeatures.gtk = true;

      # Laptop lid handling
      extraConfig = ''
        bindswitch --reload --locked lid:on output eDP-1 disable
        bindswitch --reload --locked lid:off output eDP-1 enable
      '';

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

        defaultWorkspace = "workspace number 1";

        assigns = cfg.appWorkspace;

        workspaceOutputAssign = cfg.workspaceOutput;

        startup = [
          { command = "waybar"; }
          { command = "nm-applet"; }
          { command = "udiskie --tray"; }
          { command = "1password --silent"; }
        ] ++ cfg.startup;

        input = {
          "type:keyboard" = {
            xkb_layout = "us,cz(qwerty)";
            xkb_options = "grp:alt_shift_toggle,caps:escape";
          };
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
          };
        };

        output = {
          "*" = {
            bg = "~/Pictures/wallpaper.png fill";
          };
        };

        keybindings = lib.mkOptionDefault {
          # Start a terminal
          "${mod}+Return" = "exec " + config.user-modules.common.terminal;

          # Open a program launcher
          "${mod}+d" = "exec wofi --show drun";

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
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

          # Media keys
          "XF86AudioPlay" = "exec ~/.config/i3/player-control.sh toggle";
          "XF86AudioNext" = "exec ~/.config/i3/player-control.sh next";
          "XF86AudioPrev" = "exec ~/.config/i3/player-control.sh prev";
          "XF86AudioStop" = "exec ~/.config/i3/player-control.sh stop";

          # Sreen brightness controls (brightness up, brightness down)
          "XF86MonBrightnessUp" = "exec brightnessctl set 10%+";
          "XF86MonBrightnessDown" = "exec  brightnessctl set 10%-";

          # Printscreen saves screenshot (with shift only focused window)
          "Print" = "exec grim";
          "Shift+Print" = "exec grim -g \"$(swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.focused) | .rect | \"\\(.x),\\(.y) \\(.width)x\\(.height)\"')\"";
          "Ctrl+Print" = "exec grim -g \"$(slurp)\"";

          # Applications
          "${mod}+i" = "exec ${config.user-modules.common.browser}";
          "${mod}+o" = "exec emacsclient -c";
          "${mod}+p" = "exec obsidian";

          # Modes
          "${mod}+r" = "mode resize";
          "${mod}+n" = "mode \"${powerControlMode}\"";
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
          l = "exec swaylock -k -i ~/Pictures/wallpaper.png; mode default";
          o = "exec swaymsg exit; mode default";
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
