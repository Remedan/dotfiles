{ config, lib, pkgs, modulesPath, ... }:

{
  imports = import ./../../modules/system;

  boot = {
    # V Generated by nixos-generate-config V
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    # ^------------------------------------^

    loader.efi.canTouchEfiVariables = true;
    # We need to use grub for luks support
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
    };
    loader.efi.efiSysMountPoint = "/boot/efi";
    # Thanks to this keyfile we don't need to enter the luks password twice
    # https://wiki.archlinux.org/title/Dm-crypt/Device_encryption#With_a_keyfile_embedded_in_the_initramfs
    initrd.secrets = {
      "/crypto_keyfile.bin" = "/root/secrets/crypto_keyfile.bin";
    };
    initrd.luks.devices = {
      root = {
        device = "/dev/disk/by-uuid/6be4f120-522f-4fc6-8b58-937c5fe36791";
        keyFile = "/crypto_keyfile.bin";
        preLVM = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0c96f3db-9493-414d-9fa2-320ed4e961ae";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/0c96f3db-9493-414d-9fa2-320ed4e961ae";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/0c96f3db-9493-414d-9fa2-320ed4e961ae";
      fsType = "btrfs";
      options = [ "subvol=@nix" "noatime" ];
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/37EA-85F9";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/1793e94c-0418-4f2d-902c-95d209006bde"; }
  ];

  system-modules = {
    common = {
      userName = "remedan";
      hostName = "rincewind";
      cpuType = "intel";
    };
  };

  programs.steam.enable = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.flatpak.enable = true;
}
