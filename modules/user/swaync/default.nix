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
    home.packages = with pkgs; [
      swaynotificationcenter
    ];
    xdg.configFile."swaync/config.json".source = ./config.json;
    systemd.user.services.swaync = {
      Unit = {
        Description = "Sway Notification Center";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        Restart = "always";
        RestartSec = 3;
      };
    };
  };
}
