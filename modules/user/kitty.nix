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
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
      };
    };
    home.shellAliases = {
      s = "kitten ssh";
    };
  };
}
