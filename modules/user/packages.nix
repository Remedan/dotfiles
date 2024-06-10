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
      "jetbrains-toolbox"
      "obsidian"
      "slack"
      "spotify"
      "steam"
      "steam-original"
      "steam-run"
      "terraform"
      "uhk-agent"
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
      nix-index
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
      uhk-agent
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
      jetbrains-toolbox
      jq
      nix-direnv
      postgresql
      quickemu
      tig
      xxd

      # Python
      poetry
      python3

      # Rust
      rustup

      # Common Lisp
      sbcl

      # Clojure
      leiningen

      # Infrastructure
      krew
      kubectl
      terraform
      winbox

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
