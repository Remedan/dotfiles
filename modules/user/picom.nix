{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.picom;
in
{
  options.user-modules.picom = {
    enable = mkEnableOption "picom";
  };
  config = mkIf cfg.enable {
    services.picom = {
      enable = true;

      settings = {
        # Shadow
        shadow = true;
        shadow-radius = 5;
        shadow-offset-x = -5;
        shadow-offset-y = -5;
        shadow-opacity = 0.75;
        shadow-exclude = [
          "name = 'oneko'"
          "class_g = 'firefox' && argb"
          "class_g = 'thunderbird' && argb"
          "_GTK_FRAME_EXTENTS@:c"
          "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
        ];
        shadow-ignore-shaped = false;

        # Opacity
        blur-background = true;
        blur-background-frame = true;
        blur-background-fixed = true;
        blur = {
          method = "dual_kawase";
          strength = 5;
        };
        blur-background-exclude = [
          "class_g = 'firefox' && argb"
          "class_g = 'thunderbird' && argb"
        ];
        opacity-rule = [
          "80:class_g = 'Polybar'"
          "80:class_g = 'Rofi'"
          "85:class_g = 'Alacritty' && !focused"
          "95:class_g = 'Alacritty' && focused"
          "85:class_g = 'kitty' && !focused"
          "95:class_g = 'kitty' && focused"
        ];

        # Fading
        fading = false;
        fade-delta = 3;
        no-fading-openclose = false;

        # Wintypes
        wintypes = {
          tooltip = { opacity = 0.95; shadow = false; fade = true; focus = true; };
          #dock = { shadow = false; };
          dnd = { shadow = false; };
        };

        # Other
        backend = "glx";
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        use-ewmh-active-win = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        vsync = false;
        unredir-if-possible = true;
        detect-transient = true;
        detect-client-leader = true;

        # GLX backend
        glx-no-stencil = true;
        glx-copy-from-front = false;
      };
    };
  };
}
