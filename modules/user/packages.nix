{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.packages;
in
{
  options.user-modules.packages = {
    enable = mkEnableOption "packages";
    categories.noDesktopEnvironment = mkOption {
      type = types.bool;
      default = config.user-modules.hyprland.enable;
    };
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
    home.packages = with pkgs; [
      # Core
      bat
      dig
      file
      fzf
      gnupg
      htop
      killall
      nix-search-cli
      pciutils
      ripgrep
      rlwrap
      rsync
      steam-run
      tmux
      unzip

      # Extra
      btrfs-assistant
      dconf2nix
      ghostscript
      gparted
      imagemagick
      lm_sensors
      magic-wormhole
      ncdu
      neofetch
      nmap
      obs-studio
      openvpn
      pwgen
      uhk-agent
      usbutils
      ventoy
      wl-clipboard
      yubikey-manager

      # Backup
      pika-backup

      # Audio
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
      ruff
      ruff-lsp

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
      remmina
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
      appimage-run
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
      gnome.aisleriot
      gnome.gnome-mines
      gzdoom
      ifm
      openttd
      prismlauncher # Minecraft
      scummvm
      wesnoth
    ] ++ optionals cfg.categories.noDesktopEnvironment [
      # Packages that are useful without a full DE
      baobab
      gnome.gnome-software
      networkmanagerapplet
      pavucontrol
      sxiv
      udiskie
      xsane
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
