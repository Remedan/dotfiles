{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.hyprland;
in
{
  options.user-modules.hyprland = {
    enable = mkEnableOption "Hyprland";
    nvidia = mkOption {
      type = types.bool;
      default = false;
    };
    startup = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      hyprlock
      hyprpaper
      hyprpicker
      slurp
      wdisplays
      wev
      (writeShellScriptBin "powermenu" ''
        entries=" Lock\n Logout\n⏾ Suspend\n Hibernate\n⭮ Reboot\n⏻ Shutdown"

        selected=$(echo -e $entries | wofi --width 250 --height 210 --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

        case $selected in
          lock)
            hyprlock;;
          logout)
            hyprctl dispatch exit;;
          suspend)
            systemctl suspend;;
          hibernate)
            systemctl hibernate;;
          reboot)
            systemctl reboot;;
          shutdown)
            systemctl poweroff;;
        esac
      '')
    ];
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ~/Pictures/wallpaper.png
      wallpaper = ,~/Pictures/wallpaper.png
      splash = false
    '';
    user-modules = {
      waybar.enable = mkDefault true;
      swaync.enable = mkDefault true;
      wofi.enable = mkDefault true;
    };
    services.copyq.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      settings =
        let
          mainMod = "SUPER";
          terminal = config.user-modules.common.terminal;
        in
        {
          monitor = [
            ",preferred,auto,auto"
            "eDP-1,preferred,auto,1"
          ];

          env = [
            "XCURSOR_SIZE,24"
            "QT_QPA_PLATFORMTHEME,qt5ct"
            # Enable wayland for chromium-based apps
            "NIXOS_OZONE_WL,1"
          ] ++ optionals cfg.nvidia [
            "LIBVA_DRIVER_NAME,nvidia"
            "XDG_SESSION_TYPE,wayland"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "WLR_NO_HARDWARE_CURSORS,1"
          ];

          exec-once = [
            "hyprpaper"
            "waybar"
            "nm-applet"
            "udiskie --tray"
            "1password --silent"
          ] ++ cfg.startup;

          input = {
            kb_layout = "us,cz(qwerty)";
            kb_options = "grp:alt_shift_toggle,caps:escape";

            follow_mouse = 1;

            touchpad = {
              natural_scroll = "yes";
            };
          };

          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";

            layout = "dwindle";

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false;
          };

          decoration = {
            rounding = 10;

            blur = {
              enabled = true;
              size = 3;
              passes = 1;
            };

            drop_shadow = "yes";
            shadow_range = 4;
            shadow_render_power = 3;
            "col.shadow" = "rgba(1a1a1aee)";
          };

          animations = {
            enabled = "yes";

            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };

          dwindle = {
            pseudotile = "yes";
            preserve_split = "yes";
            force_split = 2;
            no_gaps_when_only = 1;
          };

          gestures = {
            workspace_swipe = true;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          windowrulev2 = [
            "suppressevent maximize, class:.*"
            "float, class:copyq"
          ];

          bind = [
            "${mainMod}, RETURN, exec, ${terminal}"
            "${mainMod} SHIFT, Q, killactive,"
            "${mainMod} SHIFT, E, exit,"
            "${mainMod} SHIFT, SPACE, togglefloating,"
            "${mainMod}, D, exec, wofi --show drun"
            "${mainMod} SHIFT, P, pseudo," # dwindle
            "${mainMod}, V, togglesplit," # dwindle
            "${mainMod}, N, exec, powermenu"

            # Move focus with mainMod + hjkl, arrow keys
            "${mainMod}, H, movefocus, l"
            "${mainMod}, J, movefocus, d"
            "${mainMod}, K, movefocus, u"
            "${mainMod}, L, movefocus, r"
            "${mainMod}, left, movefocus, l"
            "${mainMod}, down, movefocus, d"
            "${mainMod}, up, movefocus, u"
            "${mainMod}, right, movefocus, r"

            # Move window with mainMod + hjkl, arrow keys
            "${mainMod} SHIFT, H, movewindow, l"
            "${mainMod} SHIFT, J, movewindow, d"
            "${mainMod} SHIFT, K, movewindow, u"
            "${mainMod} SHIFT, L, movewindow, r"
            "${mainMod} SHIFT, left, movewindow, l"
            "${mainMod} SHIFT, down, movewindow, d"
            "${mainMod} SHIFT, up, movewindow, u"
            "${mainMod} SHIFT, right, movewindow, r"

            # Switch workspaces with mainMod + [0-9]
            "${mainMod}, 1, workspace, 1"
            "${mainMod}, 2, workspace, 2"
            "${mainMod}, 3, workspace, 3"
            "${mainMod}, 4, workspace, 4"
            "${mainMod}, 5, workspace, 5"
            "${mainMod}, 6, workspace, 6"
            "${mainMod}, 7, workspace, 7"
            "${mainMod}, 8, workspace, 8"
            "${mainMod}, 9, workspace, 9"
            "${mainMod}, 0, workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "${mainMod} SHIFT, 1, movetoworkspace, 1"
            "${mainMod} SHIFT, 2, movetoworkspace, 2"
            "${mainMod} SHIFT, 3, movetoworkspace, 3"
            "${mainMod} SHIFT, 4, movetoworkspace, 4"
            "${mainMod} SHIFT, 5, movetoworkspace, 5"
            "${mainMod} SHIFT, 6, movetoworkspace, 6"
            "${mainMod} SHIFT, 7, movetoworkspace, 7"
            "${mainMod} SHIFT, 8, movetoworkspace, 8"
            "${mainMod} SHIFT, 9, movetoworkspace, 9"
            "${mainMod} SHIFT, 0, movetoworkspace, 10"

            # Example special workspace (scratchpad)
            "${mainMod}, S, togglespecialworkspace, magic"
            "${mainMod} SHIFT, S, movetoworkspace, special:magic"

            # Scroll through existing workspaces with mainMod + scroll
            "${mainMod}, mouse_down, workspace, m+1"
            "${mainMod}, mouse_up, workspace, m-1"

            # Move through workspaces
            "${mainMod}, period, workspace, m+1"
            "${mainMod}, comma, workspace, m-1"

            # Move through workspaces with mouse forward/backward
            ", mouse:276, workspace, m+1"
            ", mouse:275, workspace, m-1"

            # Applications
            "${mainMod}, i, exec, ${config.user-modules.common.browser}"
            "${mainMod}, o, exec, emacsclient -c"
            "${mainMod}, p, exec, obsidian"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "${mainMod}, mouse:272, movewindow"
            "${mainMod}, mouse:273, resizewindow"
          ];
        };
    };
  };
}
