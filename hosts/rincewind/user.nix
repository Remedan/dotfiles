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
