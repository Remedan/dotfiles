{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.nixgl;
in
{
  options.modules.nixgl = {
    enable = mkEnableOption "nixGL";
  };
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.nixgl.auto.nixGLDefault
      (pkgs.writeShellScriptBin "run-alacritty" ''
        nixGL alacritty
      '')
    ];
  };
}
