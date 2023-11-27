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
    nixpkgs.config.allowUnfreePredicate = pkg: elem (lib.getName pkg) [
      "obsidian"
      "spotify"
      "steam"
      "steam-original"
      "steam-run"
      "terraform"
    ];
    home.packages = with pkgs; [
      # Core
      bat
      cmake
      dig
      fzf
      gcc
      gnumake
      gnupg
      htop
      nix-search-cli.packages.${pkgs.system}.default
      pciutils
      playerctl
      pwgen
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
      ventoy

      # Dev
      awscli2
      blackbox
      direnv
      jq
      krew
      kubectl
      nix-direnv
      postgresql
      python3
      python3Packages.virtualenv
      python3Packages.virtualenvwrapper
      rustup
      terraform
      xxd

      # Graphical
      baobab
      bottles
      bruno
      filezilla
      firefox
      gimp
      gparted
      lutris
      mpv
      networkmanagerapplet
      obsidian
      spotify
      thunderbird
      udiskie
      wineWowPackages.stable
      winetricks
    ];
  };
}
