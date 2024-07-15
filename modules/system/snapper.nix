{ config, lib, ... }:
with lib;
let
  cfg = config.system-modules.snapper;
in
{
  options.system-modules.snapper = {
    enable = mkEnableOption "Snapper";
  };

  config = mkIf cfg.enable {
    services.snapper.configs.home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ config.system-modules.common.userName ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
    };
    systemd.tmpfiles.rules = [
      "v /home/.snapshots 0770 root root"
    ];
  };
}
