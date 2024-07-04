{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.gnome;
in
{
  options.user-modules.gnome = {
    enable = mkEnableOption "Gnome";
  };
  config = mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
    };
  };
}
