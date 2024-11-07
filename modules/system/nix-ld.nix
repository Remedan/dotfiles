{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.system-modules.nix-ld;
in
{
  options.system-modules.nix-ld = {
    enable = mkEnableOption "nix-ld";
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = pkgs.appimageTools.defaultFhsEnvArgs.targetPkgs pkgs;
    };
  };
}
