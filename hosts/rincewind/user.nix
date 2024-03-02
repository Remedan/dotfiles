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
        common = {
          colorscheme = "gruvbox-dark";
          terminal = "kitty";
        };
        zsh.enable = true;
        kitty.enable = true;
        emacs.enable = true;
        dunst.enable = true;
        git.enable = true;
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
        mpd.enable = true;
        fonts.enable = true;
        packages.enable = true;
        picom.enable = true;
        polybar = {
          enable = true;
          laptopModules = true;
        };
        rofi.enable = true;
        zathura.enable = true;
        gtk.enable = true;
        ssh.enable = true;
        hyprland.enable = true;
        touchpad = {
          enable = true;
          deviceName = "SynPS/2 Synaptics TouchPad";
        };
      };
    }
  ] ++ import ./../../modules/user;
}
