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
    nixpkgs.config.allowUnfreePredicate = pkg: elem (lib.getName pkg) [
      "1password"
      "discord"
      "obsidian"
      "slack"
      "spotify"
      "steam"
      "steam-original"
      "steam-run"
      "terraform"
      "winbox"
    ];
    # Obsidian still uses an EOL version of Electron
    # https://github.com/NixOS/nixpkgs/issues/273611#issuecomment-1858755633
    nixpkgs.config.permittedInsecurePackages =
      lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";
    home.packages = with pkgs; [
      # Core
      bat
      brightnessctl
      cmake
      dig
      file
      fzf
      gcc
      gnumake
      gnupg
      htop
      nix-search-cli
      pciutils
      pwgen
      ranger
      ripgrep
      rlwrap
      rsync
      steam-run
      tig
      unzip

      # Extra
      arandr
      baobab
      btdu
      caffeine-ng
      feh
      ghostscript
      gparted
      imagemagick
      jdk17
      libsForQt5.kgpg
      lm_sensors
      neofetch
      networkmanagerapplet
      nmap
      openvpn
      scrot
      sxiv
      udiskie
      ventoy
      xautolock
      xclip
      xsane
      yubikey-manager

      # Audio
      pavucontrol
      playerctl
      pulseaudio
      spotify

      # Video
      mpv

      # Development
      awscli2
      blackbox
      bruno
      direnv
      jq
      krew
      kubectl
      nix-direnv
      postgresql
      python3
      python3Packages.virtualenv
      python3Packages.virtualenvwrapper
      quickemu
      rustup
      terraform
      winbox
      xxd
      bfg-repo-cleaner

      # Internet
      chromium
      deluge
      filezilla
      firefox
      thunderbird

      # Compatibility
      bottles
      lutris
      wineWowPackages.stable
      winetricks

      # Messaging
      discord
      element-desktop
      slack

      # Graphics
      blender
      gimp
      prusa-slicer

      # Notes
      logseq
      obsidian

      # Games
      brogue-ce
      crawl
      fish-fillets-ng
      gargoyle
      gzdoom
      ifm
      openttd
      prismlauncher # Minecraft
      wesnoth

      # Game Emulators
      (retroarch.override {
        cores = with libretro; [
          bsnes
        ];
      })
    ];
  };
}
