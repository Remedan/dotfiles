{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.rofi;
in
{
  options.user-modules.rofi = {
    enable = mkEnableOption "Rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      font = "Open Sans 12";
      terminal = config.user-modules.common.terminal;
      theme = config.user-modules.common.colorscheme;
    };
    xdg.configFile = {
      "rofi/dracula.rasi".source = ../dotfiles/config/rofi/dracula.rasi;
      "rofi/nord.rasi".source = ../dotfiles/config/rofi/nord.rasi;
      "rofi/selenized-dark.rasi".source = ../dotfiles/config/rofi/selenized-dark.rasi;
    };
  };
}
