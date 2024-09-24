{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.system-modules.common;
in
{
  options.system-modules.common = {
    userName = mkOption {
      type = types.str;
    };
    hostName = mkOption {
      type = types.str;
    };
    cpuType = mkOption {
      type = with types; nullOr (enum [ "amd" "intel" ]);
      default = null;
    };
    hyprland = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "24.05";

    # Install common non-free firmware
    hardware.enableRedistributableFirmware = true;

    # Update CPU microcode
    hardware.cpu = {
      amd.updateMicrocode = cfg.cpuType == "amd";
      intel.updateMicrocode = cfg.cpuType == "intel";
    };

    # Firmware upgrades
    services.fwupd.enable = true;

    # Enable periodic SSD trim
    services.fstrim.enable = true;

    # Regularly scrub btrfs filesystems
    services.btrfs.autoScrub.enable = true;

    # Networking
    networking = {
      useDHCP = lib.mkDefault true;
      hostName = cfg.hostName;
      networkmanager.enable = true;
    };

    # Allow KDEConnect
    networking.firewall = rec {
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };

    time.timeZone = "Europe/Prague";

    # Set language to English but formats to Czech
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "cs_CZ.UTF-8";
      LC_IDENTIFICATION = "cs_CZ.UTF-8";
      LC_MEASUREMENT = "cs_CZ.UTF-8";
      LC_MONETARY = "cs_CZ.UTF-8";
      LC_NAME = "cs_CZ.UTF-8";
      LC_NUMERIC = "cs_CZ.UTF-8";
      LC_PAPER = "cs_CZ.UTF-8";
      LC_TELEPHONE = "cs_CZ.UTF-8";
      LC_TIME = "cs_CZ.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    programs.hyprland.enable = cfg.hyprland;
    security.pam.services.hyprlock = mkIf cfg.hyprland { };

    # XDG Desktop Portal
    services.dbus.enable = true;
    xdg.portal.enable = true;

    # Printing
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        canon-cups-ufr2
        cnijfilter2
      ];
    };

    # Network Printer Discovery
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Scanning
    hardware.sane.enable = true;

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = cfg.hyprland;

    # SSH Server
    services.openssh = {
      enable = lib.mkDefault true;
      settings.PasswordAuthentication = lib.mkDefault false;
    };

    # User setup
    users.groups.${cfg.userName} = {
      gid = 1000;
    };
    users.users.${cfg.userName} = {
      uid = 1000;
      group = cfg.userName;
      isNormalUser = true;
      description = "Vojtěch Balák";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "libvirtd"
        "scanner"
        "lp"
        "video"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQOh94Y3qiel5HPE9I7/mKotaFTLpeC4CD2sSZ9qr0d"
      ];
    };

    nix = {
      settings.trusted-users = [ "root" cfg.userName ];
      optimise.automatic = true;
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };
    };

    # Packages and Applications
    environment.systemPackages = with pkgs; [
      cifs-utils
      git
      vim
      wget
    ];

    programs.zsh.enable = true;
    programs._1password.enable = true;
    programs._1password-gui.enable = true;
    programs._1password-gui.polkitPolicyOwners = [ cfg.userName ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "canon-cups-ufr2"
      "cnijfilter2"
      "cuda_cccl"
      "cuda_cudart"
      "cuda_nvcc"
      "libcublas"
      "nvidia-settings"
      "nvidia-x11"
      "steam"
      "steam-original"
      "steam-run"
      "uhk-agent"
      "uhk-udev-rules"
    ];

    # Flatpak
    services.flatpak.enable = true;

    # Gnome Keyring
    services.gnome.gnome-keyring.enable = true;

    # Enable Logitech devices support and Solaar
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;

    # Udev
    services.udev.packages = with pkgs; [
      yubikey-personalization
      uhk-udev-rules
    ];

    # Smart Card / Yubikey support
    services.pcscd.enable = true;

    # Virtualisation
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
      autoPrune = {
        enable = true;
        flags = [ "--all" "--volumes" ];
      };
    };
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    # Polkit
    # https://wiki.nixos.org/wiki/Polkit#Authentication_agents
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # Udev rules for SwayOSD
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';

    # Gaming
    programs.steam.enable = true;
    programs.gamemode.enable = true;

    # Local LLMs
    services.ollama = {
      enable = true;
      acceleration = mkIf config.system-modules.nvidia.enable "cuda";
    };
    services.open-webui = {
      enable = true;
      environment = {
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        # Disable authentication
        WEBUI_AUTH = "False";
      };
    };

    # Trezor
    services.trezord.enable = true;

    # Custom Modules
    system-modules.snapper.enable = mkDefault true;
  };
}
