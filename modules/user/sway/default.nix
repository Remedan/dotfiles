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
      type = with types; listOf str;
      default = [ ];
    };
    swayidle = mkOption {
      type = types.bool;
      default = true;
    };
    nvidia = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      slurp
      wdisplays
      wev
    ];
    user-modules = {
      waybar.enable = mkDefault true;
      swaync.enable = mkDefault true;
      fuzzel.enable = mkDefault true;
    };
    xdg.configFile."swaylock/lock.png".source = ./lock.png;
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
    wayland.windowManager.sway = {
      enable = true;
      swaynag.enable = true;
      systemd.enable = true;
      wrapperFeatures.gtk = true;

      # Laptop lid handling and workspace switching
      extraConfig = ''
        bindswitch --reload --locked lid:on output eDP-1 disable
        bindswitch --reload --locked lid:off output eDP-1 enable
        bindgesture swipe:right workspace prev_on_output
        bindgesture swipe:left workspace next_on_output
        bindsym --whole-window button8 workspace prev_on_output
        bindsym --whole-window button9 workspace next_on_output
      '';

      extraOptions = optionals cfg.nvidia [
        "--unsupported-gpu"
      ];
      # Enable wayland for chromium-based apps
      extraSessionCommands = ''
        export NIXOS_OZONE_WL=1
      '' + (optionalString cfg.nvidia ''
        export WLR_NO_HARDWARE_CURSORS=1
      '');

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
          { class = "copyq"; }
        ];

        colors = import ./colors/${cfg.colorscheme}.nix;

        defaultWorkspace = "workspace number 1";

        assigns = cfg.appWorkspace;

        workspaceOutputAssign = cfg.workspaceOutput;

        startup = map (command: { inherit command; }) ([
          "nm-applet"
          "blueman-applet"
          "udiskie --tray"
          "1password --silent"
        ] ++ cfg.startup);

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
          "${mod}+d" = "exec fuzzel";

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
          "${mod}+comma" = "workspace prev_on_output";
          "${mod}+period" = "workspace next_on_output";

          # Quick workspace moving
          "${mod}+Shift+comma" = "move workspace to output right";
          "${mod}+Shift+period" = "move workspace to output left";

          # Gap control
          "${mod}+y" = "gaps inner current minus 6";
          "${mod}+u" = "gaps inner current plus 6";
          "${mod}+Shift+y" = "gaps outer current minus 6";
          "${mod}+Shift+u" = "gaps outer current plus 6";

          # Audio controls
          "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
          "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
          "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
          "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";

          # Playback controls
          "XF86AudioPlay" = "exec playerctl --ignore-player=firefox play-pause";
          "XF86AudioNext" = "exec playerctl --ignore-player=firefox next";
          "XF86AudioPrev" = "exec playerctl --ignore-player=firefox previous";
          "XF86AudioStop" = "exec playerctl --ignore-player=firefox stop";

          # Sreen brightness controls
          "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
          "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";

          # Printscreen saves screenshot (with shift only focused window)
          "Print" = "exec grim";
          "Shift+Print" = "exec grim -g \"$(swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.focused) | .rect | \"\\(.x),\\(.y) \\(.width)x\\(.height)\"')\"";
          "Ctrl+Print" = "exec grim -g \"$(slurp)\"";

          # Applications
          "${mod}+i" = "exec ${config.user-modules.common.browser}";
          "${mod}+o" = "exec emacsclient -c";
          "${mod}+p" = "exec copyq show";

          # 1Password quick access
          "Ctrl+Shift+Space" = "exec 1password --quick-access";

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
          l = "exec swaylock; mode default";
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
