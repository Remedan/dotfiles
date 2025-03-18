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
    home.shellAliases.lmstudio-wayland = "lmstudio --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto";
    nixpkgs.config.allowUnfreePredicate = pkg: elem (lib.getName pkg) [
      "1password"
      "jetbrains-toolbox"
      "lmstudio"
      "obsidian"
      "slack"
      "spotify"
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
      "terraform"
      "trezor-suite"
      "uhk-agent"
      "vscode"
      "winbox"
    ];
    home.packages = with pkgs; [
      # Core
      bat
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

      # Networking
      dig
      ethtool
      iperf
      nmap
      tcpdump
      traceroute
      wireguard-tools

      # Extra
      btop
      btrfs-assistant
      fd
      ghostscript
      gnome-solanum
      gparted
      imagemagick
      ispell
      lm_sensors
      magic-wormhole
      ncdu
      neofetch
      nix-tree
      ntfs3g
      progress
      pv
      pwgen
      trezor-suite
      trezorctl
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
      ffmpeg
      mpv
      obs-studio

      # Development
      bfg-repo-cleaner
      bruno
      cmake
      direnv
      dive
      gcc
      gdb
      git-crypt
      godot_4
      jetbrains-toolbox
      jq
      minikube
      nix-direnv
      postgresql
      tig
      vscode

      # Python
      poetry
      python3
      ruff
      uv

      # Rust
      rustup

      # Common Lisp
      sbcl
      sbclPackages.agnostic-lizard

      # Infrastructure
      k9s
      krew
      kubectl
      remmina
      terraform
      winbox4
      wireshark

      # Internet
      chromium
      datovka
      deluge
      filezilla
      firefox
      thunderbird

      # Office
      libreoffice

      # AI
      lmstudio

      # Compatibility
      appimage-run
      bottles
      distrobox
      quickemu
      quickgui

      # Messaging
      element-desktop
      slack
      telegram-desktop
      vesktop # Discord

      # Graphics
      blender
      gimp
      inkscape
      openscad
      prusa-slicer

      # Notes
      obsidian

      # Books
      calibre

      # Games
      aisleriot
      gargoyle
      gnome-mines
      gzdoom
      ifm
      prismlauncher # Minecraft
      scummvm
    ];
  };
}
