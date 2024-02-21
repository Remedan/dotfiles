{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.alacritty;
in
{
  options.user-modules.alacritty = {
    enable = mkEnableOption "Alacritty";
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 5;
            y = 5;
          };
        };
        font = {
          normal = {
            family = "Iosevka";
            size = 11.0;
          };
        };
        colors = import ./colors/${config.user-modules.common.colorscheme}.nix;
      };
    };
  };
}
