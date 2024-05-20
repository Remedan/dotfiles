{ config, lib, ... }:
with lib;
let
  cfg = config.system-modules.boot;
in
{
  options.system-modules.boot = {
    luks = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      uuid = mkOption {
        type = types.str;
      };
    };
  };

  config = {
    boot = mkMerge [
      {
        loader.efi.canTouchEfiVariables = true;

        # Plymouth boot splash screen
        plymouth.enable = true;
      }
      (mkIf (!cfg.luks.enable) {
        loader.systemd-boot.enable = true;
      })
      (mkIf cfg.luks.enable {
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
            device = "/dev/disk/by-uuid/${cfg.luks.uuid}";
            keyFile = "/crypto_keyfile.bin";
            preLVM = true;
          };
        };
      })
    ];
  };
}
