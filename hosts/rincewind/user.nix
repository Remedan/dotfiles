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
        touchpad = {
          enable = true;
          deviceName = "SynPS/2 Synaptics TouchPad";
        };
        sway = {
          enable = true;
          startup = [
            { command = "blueman-applet"; }
          ];
        };
        hyprland = {
          enable = true;
          startup = [
            "blueman-applet"
          ];
        };
      };
    }
  ] ++ import ./../../modules/user;
}
