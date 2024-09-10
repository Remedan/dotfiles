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
      ghostscript
      gparted
      imagemagick
      lm_sensors
      magic-wormhole
      ncdu
      neofetch
      nix-tree
      nmap
      openvpn
      pwgen
      uhk-agent
      usbutils
      ventoy
      wireguard-tools
      wl-clipboard
      yubikey-manager

      # Backup
      pika-backup

      # Audio
      playerctl
      spotify

      # Video
      mpv

      # Development
      bfg-repo-cleaner
      bruno
      direnv
      dive
      git-crypt
      jetbrains-toolbox
      jq
      nix-direnv
      postgresql
      tig

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

      # Messaging
      element-desktop
      slack
      vesktop # Discord

      # Graphics
      blender
      gimp
      openscad
      prusa-slicer

      # Notes
      obsidian

      # Games
      aisleriot
      gargoyle
      gnome-mines
      gzdoom
      ifm
      prismlauncher # Minecraft
      scummvm
    ] ++ optionals cfg.categories.noDesktopEnvironment [
      # Packages that are useful without a full DE
      baobab
      birdtray
      gnome.gnome-software
      networkmanagerapplet
      pavucontrol
      sxiv
      udiskie
      xsane
    ];
  };
}
