{ pkgs, home-manager }:

home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    {
      home = {
        username = "remedan";
        homeDirectory = "/home/remedan";
      };
      user-modules = {
        i3 = {
          enable = true;
          startup = [
            {
              command = "blueman-applet";
              notification = false;
            }
            {
              command = "systemctl --user import-environment"; # this fixes some applications (e.g. Firefox) being slow to start
              notification = false;
            }
          ];
        };
        polybar.laptopModules = true;
        hyprland.enable = true;
        touchpad = {
          enable = true;
          deviceName = "SynPS/2 Synaptics TouchPad";
        };
      };
    }
  ] ++ import ./../../modules/user;
}
