{ config, lib, ... }:
with lib;

let
  cfg = config.user-modules.wofi;
in
{
  options.user-modules.wofi = {
    enable = mkEnableOption "Wofi";
  };
  config = mkIf cfg.enable {
    programs.wofi = {
      enable = true;
      settings = {
        key_forward = "Ctrl-n";
        key_backward = "Ctrl-p";
        key_expand = "Tab";
      };
    };
  };
}
