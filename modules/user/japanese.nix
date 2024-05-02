{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.user-modules.japanese;
in
{
  options.user-modules.japanese = {
    enable = mkEnableOption "Japanese Input";
  };
  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-configtool
        fcitx5-gtk
        fcitx5-mozc
      ];
    };
  };
}
