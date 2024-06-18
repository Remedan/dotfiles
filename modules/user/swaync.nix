{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.user-modules.swaync;
in
{
  options.user-modules.swaync = {
    enable = mkEnableOption "Sway Notification Center";
  };
  config = mkIf cfg.enable {
    services.swaync = {
      enable = true;
      settings = {
        positionX = "center";
        positionY = "top";
        control-center-margin-top = 10;
        control-center-margin-bottom = 10;
        control-center-margin-right = 10;
        control-center-margin-left = 10;
        widgets = [
            "inhibitors"
            "title"
            "dnd"
            "notifications"
        ];
      };
    };
  };
}
