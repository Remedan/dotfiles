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
      "obsidian"
      "rust-rover"
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
      killall
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
      wl-clipboard
      xclip
      xsane
      yubikey-manager

      # Audio
      pavucontrol
      playerctl
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
      git-crypt
      jetbrains.pycharm-community
      jetbrains.rust-rover
      jq
      krew
      kubectl
      nix-direnv
      poetry
      postgresql
      quickemu
      rust-analyzer
      terraform
      tig
      winbox
      xxd

      # Python
      python3
      python3Packages.pylsp-mypy
      python3Packages.python-lsp-server

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
      element-desktop
      slack
      vesktop # Discord

      # Graphics
      blender
      freecad
      gimp
      openscad
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
