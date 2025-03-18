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
  };

  config = {
    # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "24.11";

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
      allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };

    time.timeZone = "Europe/Prague";

    i18n =
      let
        # Set language to English but formats to Czech
        locale = "en_US.UTF-8";
        format = "cs_CZ.UTF-8";
      in
      {
        defaultLocale = locale;
        extraLocaleSettings = {
          LC_ADDRESS = format;
          LC_IDENTIFICATION = format;
          LC_MEASUREMENT = format;
          LC_MONETARY = format;
          LC_NAME = format;
          LC_NUMERIC = format;
          LC_PAPER = format;
          LC_TELEPHONE = format;
          LC_TIME = format;
        };
        inputMethod = {
          enable = true;
          type = "ibus";
          # Enable Japanese input
          ibus.engines = with pkgs.ibus-engines; [ anthy mozc ];
        };
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

    # Add the option to open a directory in Kitty to Nautilus
    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };

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

    # Enable sound with pipewire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    security.rtkit.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

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
        "adbusers"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQOh94Y3qiel5HPE9I7/mKotaFTLpeC4CD2sSZ9qr0d"
      ];
    };

    nix = {
      settings = {
        trusted-users = [ "root" cfg.userName ];
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
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
      "steam-unwrapped"
      "teamviewer"
      "uhk-agent"
      "uhk-udev-rules"
    ];

    # Flatpak
    services.flatpak.enable = true;

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
    virtualisation.spiceUSBRedirection.enable = true;

    # Polkit
    security.polkit.enable = true;

    # Gaming
    programs.steam.enable = true;
    programs.gamemode.enable = true;

    # Local LLMs
    services.ollama = {
      enable = true;
      acceleration = mkIf config.system-modules.nvidia.enable "cuda";
    };

    # Trezor
    # services.trezord.enable = true; TODO Broken package

    # Android
    programs.adb.enable = true;

    # Custom Modules
    system-modules.snapper.enable = mkDefault true;
  };
}
