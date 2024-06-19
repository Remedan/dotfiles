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
    workspaces = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
    idleLock = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      hyprpicker
      slurp
      wdisplays
      wev
      (writeShellScriptBin "powermenu" ''
          entries=" Lock\n Logout\n⏾ Suspend\n Hibernate\n⭮ Reboot\n⏻ Shutdown"

          selected=$(echo -e $entries | ${pkgs.fuzzel}/bin/fuzzel --dmenu -l 6 | awk '{print tolower($2)}')

          case $selected in
            lock)
              ${pkgs.hyprlock}/bin/hyprlock;;
            logout)
              ${pkgs.hyprland}/bin/hyprctl dispatch exit;;
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
    user-modules = {
      waybar.enable = mkDefault true;
      swaync.enable = mkDefault true;
      fuzzel.enable = mkDefault true;
    };
    services.hyprpaper = {
      enable = true;
      settings = {
        preload =  [ "~/Pictures/wallpaper.png" ];
        wallpaper = [ ",~/Pictures/wallpaper.png" ];
        splash = false;
      };
    };
    programs.hyprlock = {
      enable = true;
      settings = {
        background = {
          monitor = "";
          path = "screenshot";
          blur_size = 8;
          blur_passes = 3;
        };

        input-field = {
          monitor = "";
        };

        label = {
          monitor = "";
          text = "$LAYOUT";
        };
      };
    };
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          # avoid starting multiple hyprlock instances.
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          # lock before suspend.
          before_sleep_cmd = "loginctl lock-session";
          # to avoid having to press a key twice to turn on the display.
          after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        };

        listener = [
          {
            # 5 minutes
            timeout = 300;
            # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
            # monitor backlight restore.
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            # 10 minutes
            timeout = 600;
            # lock screen when timeout has passed
            on-timeout = "loginctl lock-session";
          }
          {
            # 11 minutes
            timeout = 660;
            # screen off when timeout has passed
            on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
            # screen on when activity is detected after timeout has fired.
            on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
          }
        ];
      };
    };
    services.swayosd.enable = true;
    services.copyq.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      settings = {
        "$mod" = "SUPER";

        monitor = [
          "eDP-1,preferred,auto,1.25"
          ",preferred,auto,${if config.user-modules.common.hidpi then "1.25" else "auto"}"
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
        ];

        # XWayland apps are blurry when using fractional scaling
        xwayland = {
          force_zero_scaling = true;
        };

        exec-once = [
          "nm-applet"
          "blueman-applet"
          "udiskie --tray"
          "1password --silent"
        ] ++ cfg.startup;

        input = {
          kb_layout = "us,cz(qwerty)";
          kb_options = "grp:alt_shift_toggle,caps:escape";

          follow_mouse = 1;

          touchpad = {
            natural_scroll = true;
          };
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgb(676d3d)";
          "col.inactive_border" = "rgb(323232)";

          layout = "dwindle";

          cursor_inactive_timeout = 10;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
        };

        decoration = {
          rounding = 10;

          drop_shadow = true;
          shadow_range = 20;

          blur = {
            enabled = true;
            size = 8;
            passes = 3;
          };
        };

        animations = {
          enabled = true;
          animation = [
            "windows, 1, 3, default"
            "windowsOut, 1, 3, default, popin 80%"
            "border, 1, 3, default"
            "fade, 1, 3, default"
            "workspaces, 1, 3, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2;
          no_gaps_when_only = 1;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_forever = true;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        windowrulev2 = [
          "suppressevent maximize, class:.*"
          "stayfocused, title:Quick Access — 1Password"
          "stayfocused, class:polkit-gnome-authentication-agent-1"
          "float, class:copyq"
        ];

        layerrule = [
          "blur, launcher"
          "blur, waybar"
        ];

        workspace = cfg.workspaces;

        bind = [
          # General window manipulation
          "$mod, RETURN, exec, ${config.user-modules.common.terminal}"
          "$mod SHIFT, Q, killactive,"
          "$mod SHIFT, E, exit,"
          "$mod SHIFT, SPACE, togglefloating,"
          "$mod, D, exec, ${pkgs.fuzzel}/bin/fuzzel"
          "$mod SHIFT, D, exec, ${pkgs.bemoji}/bin/bemoji"
          "$mod SHIFT, P, pseudo," # dwindle
          "$mod, V, togglesplit," # dwindle
          "$mod, N, exec, powermenu"
          "$mod, F, fullscreen, 1"
          "$mod SHIFT, F, fullscreen, 0"

          # Move focus with mod + hjkl, arrow keys
          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"
          "$mod, left, movefocus, l"
          "$mod, down, movefocus, d"
          "$mod, up, movefocus, u"
          "$mod, right, movefocus, r"

          # Move window with mod + hjkl, arrow keys
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, J, movewindow, d"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, down, movewindow, d"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, right, movewindow, r"

          # Switch workspaces with mod + [0-9]
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move active window to a workspace with mod + SHIFT + [0-9]
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"

          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, m+1"
          "$mod, mouse_up, workspace, m-1"

          # Move through workspaces
          "$mod, period, workspace, m+1"
          "$mod, comma, workspace, m-1"

          # Move through workspaces with mouse forward/backward
          ", mouse:276, workspace, m+1"
          ", mouse:275, workspace, m-1"

          # Move workspaces between monitors
          "$mod SHIFT, period, movecurrentworkspacetomonitor, +1"
          "$mod SHIFT, comma,  movecurrentworkspacetomonitor, -1"

          # Grouping
          "$mod, q, togglegroup"
          "$mod, w, changegroupactive, b"
          "$mod, e, changegroupactive, f"

          # Audio controls
          ", XF86AudioRaiseVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume raise"
          ", XF86AudioLowerVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume lower"
          ", XF86AudioMute, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle"
          ", XF86AudioMicMute, exec, ${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle"

          # Playback controls
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl --ignore-player=firefox play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl --ignore-player=firefox next"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl --ignore-player=firefox previous"
          ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl --ignore-player=firefox stop"

          # Sreen brightness controls
          ", XF86MonBrightnessUp, exec, ${pkgs.swayosd}/bin/swayosd-client --brightness raise"
          ", XF86MonBrightnessDown, exec, ${pkgs.swayosd}/bin/swayosd-client --brightness lower"

          # Printscreen
          ", Print, exec, ${pkgs.grim}/bin/grim"
          "CONTROL, Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\""

          # Applications
          "$mod, i, exec, ${config.user-modules.common.browser}"
          "$mod, o, exec, emacsclient -c"
          "$mod, p, exec, copyq show"
          "CONTROL SHIFT, SPACE, exec, 1password --quick-access"
        ];

        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        # Laptop lid handling
        bindl = [
          ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
          ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, preferred, auto, 1\""
        ];
      };
      extraConfig = ''
        # Window resize
        bind = $mod, R, submap, resize

        submap = resize
        binde = , l, resizeactive, 10 0
        binde = , h, resizeactive, -10 0
        binde = , k, resizeactive, 0 -10
        binde = , j, resizeactive, 0 10
        binde = , right, resizeactive, 10 0
        binde = , left, resizeactive, -10 0
        binde = , up, resizeactive, 0 -10
        binde = , down, resizeactive, 0 10
        bind = , escape, submap, reset
        submap = reset
      '';
    };
  };
}
