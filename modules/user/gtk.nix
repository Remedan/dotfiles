{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.gtk;
in
{
  options.user-modules.gtk = {
    enable = mkEnableOption "GTK";
  };
  config = mkIf cfg.enable {
    home.pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    gtk = {
      enable = true;
      theme.package = pkgs.adwaita-icon-theme;
      theme.name = "Adwaita";
      cursorTheme.package = pkgs.adwaita-icon-theme;
      cursorTheme.name = "Adwaita";
      cursorTheme.size = 24;
      iconTheme.package = pkgs.adwaita-icon-theme;
      iconTheme.name = "Adwaita";
      gtk2.extraConfig = ''
        gtk-application-prefer-dark-theme=1
      '';
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
