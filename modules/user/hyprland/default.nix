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
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprpaper
      wdisplays
      wofi
    ];
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ~/Pictures/wallpaper.png
      wallpaper = ,~/Pictures/wallpaper.png
      splash = false
    '';
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          modules-left = [
            "hyprland/workspaces"
            "pulseaudio"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "hyprland/language"
            "disk"
            "cpu"
            "memory"
            "backlight"
            "battery"
            "tray"
          ];
        };
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      settings =
        let
          mainMod = "SUPER";
          terminal = config.user-modules.common.terminal;
        in
        {
          # See https://wiki.hyprland.org/Configuring/Monitors/
          monitor = [
            ",preferred,auto,auto"
            "eDP-1,preferred,auto,1"
          ];

          env = [
            "XCURSOR_SIZE,24"
            "QT_QPA_PLATFORMTHEME,qt5ct"
          ] ++ optionals cfg.nvidia [
            "LIBVA_DRIVER_NAME,nvidia"
            "XDG_SESSION_TYPE,wayland"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "WLR_NO_HARDWARE_CURSORS,1"
          ];

          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/

          exec-once = [
            "waybar"
            "hyprpaper"
            "nm-applet"
            "udiskie --tray"
            "blueman-applet"
            "1password --silent"
          ];

          input = {
            kb_layout = "us";

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

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

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
            # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
            pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = "yes"; # you probably want this

            no_gaps_when_only = 1;
          };

          master = {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_is_master = true;
          };

          gestures = {
            workspace_swipe = true;
          };

          misc = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          # Example windowrule v1
          # windowrule = float, ^(kitty)$
          # Example windowrule v2
          # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
          # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
          windowrulev2 = [
            "nomaximizerequest, class:.*"
          ];

          bind = [
            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            "${mainMod}, RETURN, exec, ${terminal}"
            "${mainMod} SHIFT, Q, killactive,"
            "${mainMod} SHIFT, E, exit,"
            "${mainMod} SHIFT, SPACE, togglefloating,"
            "${mainMod}, D, exec, wofi --show drun"
            "${mainMod}, P, pseudo," # dwindle
            "${mainMod}, V, togglesplit," # dwindle

            # Move focus with mainMod + hjkl
            "${mainMod}, H, movefocus, l"
            "${mainMod}, J, movefocus, d"
            "${mainMod}, K, movefocus, u"
            "${mainMod}, L, movefocus, r"

            # Move window with mainMod + hjkl
            "${mainMod} SHIFT, H, movewindow, l"
            "${mainMod} SHIFT, J, movewindow, d"
            "${mainMod} SHIFT, K, movewindow, u"
            "${mainMod} SHIFT, L, movewindow, r"

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
            "${mainMod}, mouse_down, workspace, e+1"
            "${mainMod}, mouse_up, workspace, e-1"

            # Move through workspaces
            "${mainMod}, period, workspace, e+1"
            "${mainMod}, comma, workspace, e-1"

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
