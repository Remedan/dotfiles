{ config, lib, ... }:
with lib;

let
  cfg = config.user-modules.fuzzel;
in
{
  options.user-modules.fuzzel = {
    enable = mkEnableOption "Fuzzel";
  };
  config = mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Source Sans:size=16";
          line-height = 22;
          terminal = config.user-modules.common.terminal;
        };
        colors = {
          background = "#28282880";
          text = "ebdbb2ff";
          border = "676d3dee";
        };
      };
    };
  };
}
