{ config, lib, ... }:
with lib;
let
  cfg = config.system-modules.nvidia;
in
{
  options.system-modules.nvidia = {
    enable = mkEnableOption "Nvidia";
    driverVersion = mkOption {
      type = types.enum [ "stable" "beta" ];
      default = "stable";
    };
  };

  config = mkIf cfg.enable {
    # Taken from https://wiki.nixos.org/wiki/Nvidia#Modifying_NixOS_configuration

    # Enable graphics driver
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Select the driver version
      # https://wiki.nixos.org/wiki/Nvidia#Determining_the_correct_driver_version
      package = config.boot.kernelPackages.nvidiaPackages.${cfg.driverVersion};
    };
  };
}
