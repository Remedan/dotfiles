{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.flatpak;
in
{
  options.user-modules.flatpak = {
    enable = mkEnableOption "Flatpak";
  };
  config = mkIf cfg.enable {
    services.flatpak = {
      enable = true;
      packages = [
        "com.adamcake.Bolt"
        "org.gnome.Polari"
      ];
    };
  };
}
