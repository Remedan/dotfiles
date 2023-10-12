{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.packages;
in
{
  options.user-modules.packages = {
    enable = mkEnableOption "packages";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Core
      cmake
      fzf
      gcc
      gnumake
      gnupg
      playerctl
      ranger
      ripgrep
      rlwrap
      rsync
      steam-run
      tig

      # Dev
      awscli2
      blackbox
      krew
      kubectl
      postgresql
      terraform
      xxd
    ];
  };
}
