{ config, lib, pkgs, ... }:
{
  boot = {
    # V Generated by nixos-generate-config V
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    # ^------------------------------------^

    # Fixes Xbox controller pairing
    extraModprobeConfig = '' options bluetooth disable_ertm=1 '';
  };

  fileSystems =
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
      "/" = {
        device = "/dev/disk/by-uuid/6fc090b5-66e2-4870-91f0-145d46b65f84";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

      "/nix" = {
        device = "/dev/disk/by-uuid/6fc090b5-66e2-4870-91f0-145d46b65f84";
        fsType = "btrfs";
        options = [ "subvol=@nix" "noatime" ];
      };

      "/home" = {
        device = "/dev/disk/by-uuid/6fc090b5-66e2-4870-91f0-145d46b65f84";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/EE81-37E8";
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

  swapDevices = [
    { device = "/dev/disk/by-uuid/8fb1f7ff-4f1a-42c4-bc30-567e976c7a54"; }
    { device = "/dev/disk/by-uuid/589f663d-8784-4e17-9634-829edb852c59"; }
  ];

  system-modules = {
    common = {
      userName = "remedan";
      hostName = "weatherwax";
      cpuType = "amd";
    };
    nvidia.enable = true;
    nix-ld.enable = true;
  };
}
