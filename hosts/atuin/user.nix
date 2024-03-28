{ pkgs, home-manager }:

home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    {
      home = {
        username = "vojta";
        homeDirectory = "/home/vojta";
      };
      user-modules = {
        packages.categories.emulators = false;
        sway = {
          enable = true;
          workspaceOutput =
            map
              (number: {
                workspace = toString number;
                output = "DP-4";
              })
              (pkgs.lib.range 1 3)
            ++
            map
              (number: {
                workspace = toString number;
                output = "DP-5";
              })
              (pkgs.lib.range 4 10);
          appWorkspace = {
            "number 1" = [{ app_id = "firefox"; }];
            "number 2" = [{ app_id = "thunderbird"; }];
            "number 3" = [{ app_id = "obsidian"; }];
            "number 8" = [{ app_id = "Slack"; }];
            "number 9" = [{ app_id = "Spotify"; }];
          };
          startup = [
            "blueman-applet"
            "birdtray"
            "solaar -w hide"
            "firefox"
            "thunderbird"
            "obsidian"
            "swaymsg 'workspace number 4; exec kitty; exec kitty'"
            "slack"
            "swaymsg 'workspace number 9; exec spotify'"
          ];
        };
        hyprland.enable = true;
        emacs.pythonTabs = true;
        git.enable = false;
        yubikey.enable = true;
      };
    }
  ] ++ import ./../../modules/user;
}
