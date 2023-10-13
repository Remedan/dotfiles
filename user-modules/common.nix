{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.common;
in
{
  options.user-modules.common = {
    colorscheme = mkOption {
      type = types.str;
      default = "gruvbox-dark";
    };
    terminal = mkOption {
      type = types.str;
      default = "alacritty";
    };
  };
  config = mkMerge [
    {
      home = {
        stateVersion = "23.05";
        keyboard = {
          layout = "us,cz(qwerty)";
          options = [
            "grp:alt_shift_toggle"
            "caps:escape"
          ];
        };
      };
      programs.home-manager.enable = true;
    }
    (mkIf pkgs.stdenv.isLinux {
      xsession.enable = true;
      xdg.userDirs.enable = true;
    })
  ];
}
