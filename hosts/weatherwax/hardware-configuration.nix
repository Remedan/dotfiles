{ config, lib, pkgs, modulesPath, ... }:

let
  cifsOptions = [
    "_netdev"
    "nofail"
    "vers=2.1"
    "credentials=/home/remedan/.smbcredentials"
    "uid=${toString config.users.users.remedan.uid}"
    "gid=${toString config.users.groups.remedan.gid}"
  ];
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/18b6bac7-e683-40b0-9426-413977b94742";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6D27-4D37";
      fsType = "vfat";
    };

    "/home/remedan/Network/home" = {
      device = "//192.168.4.3/homes/remedan";
      fsType = "cifs";
      options = cifsOptions;
    };

    "/home/remedan/Network/Media" = {
      device = "//192.168.4.3/Media";
      fsType = "cifs";
      options = cifsOptions;
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/86f3f911-566f-4711-a884-89034309fa41"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
