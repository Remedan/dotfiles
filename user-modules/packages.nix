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
      "1password"
      "discord"
      "obsidian"
      "spotify"
      "steam"
      "steam-original"
      "steam-run"
      "terraform"
      "winbox"
    ];
    # Obsidian 1.14.6 uses an EOL version of Electron
    # https://github.com/NixOS/nixpkgs/issues/273611#issuecomment-1858755633
    nixpkgs.config.permittedInsecurePackages =
      lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";
    home.packages = with pkgs; [
      # Core
      bat
      brightnessctl
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
      unzip

      # Extra
      feh
      jdk17
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
      blender
      bottles
      bruno
      discord
      element-desktop
      filezilla
      firefox
      gimp
      gparted
      lutris
      mpv
      networkmanagerapplet
      obsidian
      pavucontrol
      prusa-slicer
      spotify
      thunderbird
      udiskie
      winbox
      wineWowPackages.stable
      winetricks

      # Games
      prismlauncher # Minecraft
      (retroarch.override {
        cores = with libretro; [
          bsnes
        ];
      })
    ];
  };
}
