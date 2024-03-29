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
    i3 = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "23.11";

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

    # Networking
    networking = {
      useDHCP = lib.mkDefault true;
      hostName = cfg.hostName;
      networkmanager.enable = true;
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
      windowManager.i3.enable = cfg.i3;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    programs.sway.enable = true;
    programs.hyprland.enable = true;

    # XDG Desktop Portal
    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };

    # Printing
    services.printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];
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
    services.blueman.enable = true;

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
    };

    # Packages and Applications
    environment.systemPackages = with pkgs; [
      cifs-utils
      git
      vim
      virt-manager
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
      "cnijfilter2"
      "nvidia-settings"
      "nvidia-x11"
      "steam"
      "steam-original"
      "steam-run"
    ];

    # Gnome Keyring
    services.gnome.gnome-keyring.enable = true;

    # Enable Logitech devices support and Solaar
    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;

    # Yubikey
    services.udev.packages = [ pkgs.yubikey-personalization ];
    # services.pcscd.enable = true;

    # Virtualisation
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
    };
    virtualisation.libvirtd.enable = true;

    # Polkit
    # https://nixos.wiki/wiki/Polkit#Authentication_agents
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
  };
}
