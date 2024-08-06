{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.ranger;
in
{
  options.user-modules.ranger = {
    enable = mkEnableOption "Ranger";
  };
  config = mkIf cfg.enable {
    programs.ranger = {
      enable = true;
      settings = mkIf config.user-modules.kitty.enable {
        preview_images = true;
        preview_images_method = "kitty";
      };
    };
    # Prepend a line to the default rifle config
    xdg.configFile."ranger/rifle.conf".text =
      "mime ^image, has loupe, X, flag f = loupe -- \"$@\"\n"
      + (readFile "${pkgs.ranger}/share/doc/ranger/config/rifle.conf");
  };
}
