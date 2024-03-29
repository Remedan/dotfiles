{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.packages;
in
{
  options.user-modules.packages = {
    enable = mkEnableOption "packages";
    categories.emulators = mkOption {
      type = types.bool;
      default = true;
    };
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
      magic-wormhole
      ncdu
      neofetch
      networkmanagerapplet
      nmap
      openvpn
      sxiv
      udiskie
      ventoy
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
      vlc

      # Development
      awscli2
      bfg-repo-cleaner
      blackbox
      bruno
      direnv
      jq
      krew
      kubectl
      nix-direnv
      postgresql
      python3
      python3Packages.pylsp-mypy
      python3Packages.python-lsp-server
      python3Packages.virtualenv
      python3Packages.virtualenvwrapper
      quickemu
      rust-analyzer
      terraform
      tig
      winbox
      xxd

      # Internet
      birdtray
      chromium
      deluge
      filezilla
      firefox
      thunderbird

      # Office
      libreoffice

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
      dosbox
      fish-fillets-ng
      gargoyle
      gzdoom
      ifm
      openttd
      prismlauncher # Minecraft
      scummvm
      wesnoth
    ] ++ optionals cfg.categories.emulators [
      # Console Emulators
      desmume
      pcsx2
      rpcs3
      (retroarch.override {
        cores = with libretro; [
          bsnes
        ];
      })
    ];
  };
}
