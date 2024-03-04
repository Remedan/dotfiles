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
        emacs.pythonTabs = true;
        i3 = {
          enable = true;
          appWorkspace = {
            "1" = [{ class = "firefox"; }];
            "2" = [{ class = "thunderbird"; }];
            "3" = [{ class = "obsidian"; }];
            "8" = [{ class = "Slack"; }];
            "9" = [{ class = "Spotify"; }];
          };
          startup = [
            {
              command = "xautolock -time 30 -locker ~/.config/i3/lock.sh";
              notification = false;
            }
            {
              command = "blueman-applet";
              notification = false;
            }
            {
              command = "birdtray";
              notification = false;
            }
            {
              command = "solaar -w hide";
              notification = false;
            }
            { command = "firefox"; }
            { command = "thunderbird"; }
            { command = "obsidian"; }
            { command = "i3-msg 'workspace number 4; exec kitty; exec kitty'"; }
            { command = "slack"; }
            { command = "spotify"; }
          ];
        };
        polybar = {
          laptopModules = true;
          bar0Override = {
            monitor = "\${env:MONITOR:DP-1-2}";
            monitor-fallback = "\${env:MONITOR:eDP-1}";
            monitor-strict = true;
            font = [
              "Symbols\ Nerd\ Font:10;2"
              "Open Sans:pixelsize=11;2"
              "Source\ Han\ Sans:pixelsize=10;2"
            ];
          };
          bar1Override = {
            monitor = "\${env:MONITOR:DP-1-3}";
            monitor-strict = true;
          };
        };
        touchpad = {
          enable = true;
          deviceName = "DELL0A20:00 0488:101A Touchpad";
        };
        git.enable = false;
        yubikey.enable = true;
        hyprland.enable = true;
      };
    }
  ] ++ import ./../../modules/user;
}
