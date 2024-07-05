{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.system-modules.nix-ld;
in
{
  options.system-modules.nix-ld = {
    enable = mkEnableOption "nix-ld";
    extraLibraries = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries = mkIf cfg.extraLibraries (
        pkgs.steam-run.fhsenv.args.multiPkgs pkgs
      );
    };
  };
}
