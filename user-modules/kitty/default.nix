{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.kitty;
in
{
  options.user-modules.kitty = {
    enable = mkEnableOption "Kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka";
        size = 11;
      };
      theme =
        let
          themeNames = {
            gruvbox-dark = "Gruvbox Dark";
          };
        in
        themeNames.${config.user-modules.common.colorscheme};
      settings = {
        window_padding_width = 5;
      };
    };
  };
}
