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
    swayidle = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      hyprpaper
      hyprpicker
      slurp
      wdisplays
      wev
      (writeShellScriptBin "powermenu" ''
        entries=" Lock\n Logout\n⏾ Suspend\n Hibernate\n⭮ Reboot\n⏻ Shutdown"

        selected=$(echo -e $entries | ${pkgs.fuzzel}/bin/fuzzel --dmenu -l 6 | awk '{print tolower($2)}')

        case $selected in
          lock)
            swaylock;;
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
      fuzzel.enable = mkDefault true;
    };
    xdg.configFile."swaylock/lock.png".source = ../i3-sway/lock.png;
    programs.swaylock = {
      enable = true;
      settings = {
        image = "~/.config/swaylock/lock.png";
        scaling = "tile";
        show-keyboard-layout = true;
      };
    };
    services.swayidle = {
      enable = cfg.swayidle;
      timeouts = [
        { timeout = 60 * 30; command = "${pkgs.swaylock}/bin/swaylock"; }
      ];
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
        { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock"; }
      ];
    };
    services.swayosd.enable = true;
    services.copyq.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      settings = {
        "$mod" = "SUPER";

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
          gaps_out = 10;
          border_size = 2;
          "col.active_border" = "rgba(676d3dee)";
          "col.inactive_border" = "rgba(323232aa)";

          layout = "dwindle";

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
        };

        decoration = {
          rounding = 10;

          blur = {
            enabled = true;
            size = 8;
            passes = 1;
          };

          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        animations = {
          enabled = "yes";

          animation = [
            "windows, 1, 3, default"
            "windowsOut, 1, 3, default, popin 80%"
            "border, 1, 3, default"
            "borderangle, 1, 3, default"
            "fade, 1, 3, default"
            "workspaces, 1, 3, default"
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

          # Applications
          "$mod, i, exec, ${config.user-modules.common.browser}"
          "$mod, o, exec, emacsclient -c"
          "$mod, p, exec, copyq show"
          "CONTROL SHIFT, SPACE, exec, copyq show"
        ];

        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        # Laptop lid handling
        bindl = [
          ",switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
          ",switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, preferred, auto, 1\""
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
