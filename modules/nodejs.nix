{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.nodejs;
in
{
  options.modules.nodejs = {
    enable = mkEnableOption "Node.js";
  };
  config = {
    home = {
      packages = with pkgs; [
        nodejs
      ];
      file.".npmrc".text = ''
        prefix = ''${HOME}/.npm-global
      '';
      sessionPath = [
        "$HOME/.npm-global/bin"
      ];
    };
  };
}
