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
    # Taken from https://nixos.wiki/wiki/Nvidia#Modifying_NixOS_Configuration

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
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

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.${cfg.driverVersion};
    };
  };
}
