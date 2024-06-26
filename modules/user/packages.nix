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
      default = false;
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
    nixpkgs.config.permittedInsecurePackages = [
      "electron-27.3.11"
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
      tmux
      unzip

      # Extra
      arandr
      baobab
      btdu
      ghostscript
      gnome.gnome-software
      gparted
      imagemagick
      lm_sensors
      magic-wormhole
      ncdu
      neofetch
      networkmanagerapplet
      nmap
      nsxiv
      obs-studio
      openvpn
      udiskie
      uhk-agent
      ventoy
      wl-clipboard
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
      bruno
      direnv
      dive
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
      k9s
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
