{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.nixgl;
in
{
  options.user-modules.nixgl = {
    enable = mkEnableOption "nixGL";
  };
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.nixgl.auto.nixGLDefault
      (pkgs.writeShellScriptBin "run-alacritty" ''
        nixGL alacritty
      '')
      (pkgs.writeShellScriptBin "run-kitty" ''
        nixGL kitty
      '')
      (pkgs.writeShellScriptBin "run-firefox" ''
        nixGL firefox
      '')
    ];
  };
}
