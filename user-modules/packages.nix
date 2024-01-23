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
      openvpn
      playerctl
      pulseaudio
      scrot
      ventoy
      yubikey-manager

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
      arandr
      baobab
      blender
      bottles
      bruno
      chromium
      discord
      element-desktop
      filezilla
      firefox
      gimp
      gparted
      logseq
      lutris
      mpv
      networkmanagerapplet
      obsidian
      pavucontrol
      prusa-slicer
      slack
      spotify
      thunderbird
      udiskie
      winbox
      wineWowPackages.stable
      winetricks

      # Games
      fish-fillets-ng
      prismlauncher # Minecraft
      (retroarch.override {
        cores = with libretro; [
          bsnes
        ];
      })
    ];
  };
}
