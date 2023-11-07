{ config, lib, pkgs, nix-search-cli, ... }:
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
      bat
      cmake
      fzf
      gcc
      gnumake
      gnupg
      htop
      nix-search-cli.packages.${pkgs.system}.default
      playerctl
      ranger
      ripgrep
      rlwrap
      rsync
      steam-run
      tig

      # Extra
      feh
      neofetch
      playerctl
      scrot

      # Dev
      awscli2
      blackbox
      direnv
      krew
      kubectl
      nix-direnv
      postgresql
      python3
      python3Packages.virtualenv
      python3Packages.virtualenvwrapper
      terraform
      xxd

      # Graphical
      firefox
      gimp
      networkmanagerapplet
      obsidian
      spotify
      thunderbird
      udiskie
    ];
  };
}
