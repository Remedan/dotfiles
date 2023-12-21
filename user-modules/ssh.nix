{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.ssh;
in
{
  options.user-modules.ssh = {
    enable = mkEnableOption "SSH";
  };
  config = mkIf cfg.enable {
    home.file.".ssh/config".text = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };
}
