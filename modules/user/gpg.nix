{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.gpg;
in
{
  options.user-modules.gpg = {
    enable = mkEnableOption "GnuPG";
  };
  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      scdaemonSettings = {
        # This allows gpg-agent and scdaemon to work together
        disable-ccid = true;
      };
    };
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
}
