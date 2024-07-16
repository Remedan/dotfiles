{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.kitty;
in
{
  options.user-modules.kitty = {
    enable = mkEnableOption "Kitty";
    colorscheme = mkOption {
      type = types.str;
      default = config.user-modules.common.colorscheme;
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Iosevka Term";
        size = 11;
      };
      theme =
        let
          themeNames = {
            selenized-dark = "Solarized Dark";
            gruvbox-dark = "Gruvbox Dark";
          };
        in
          themeNames.${cfg.colorscheme} or cfg.colorscheme;
      settings = {
        window_padding_width = 5;
      };
    };
    home.shellAliases = {
      s = "kitten ssh";
    };
    xdg.configFile."ranger/rc.conf".text = ''
      set preview_images true
      set preview_images_method kitty
    '';
  };
}
