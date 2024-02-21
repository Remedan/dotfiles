{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.zathura;
in
{
  options.user-modules.zathura = {
    enable = mkEnableOption "Zathura";
  };

  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        guioptions = "sv";
      };
    };
  };
}
