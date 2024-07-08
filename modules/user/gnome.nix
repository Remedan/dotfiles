{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.gnome;
in
{
  options.user-modules.gnome = {
    enable = mkEnableOption "Gnome";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnome.gnome-tweaks
      gnomeExtensions.appindicator
    ];
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
      };
      "org/gnome/desktop/wm/preferences" = {
        focus-mode = "mouse";
      };
      "org/gnome/shell" = {
        enabled-extensios = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
        ];
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        edge-tiling = true;
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
      "org/gnome/shell/app-switcher" = {
        current-workspace-only = true;
      };
    };
  };
}
