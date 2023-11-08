{ pkgs, home-manager, extraSpecialArgs }:

home-manager.lib.homeManagerConfiguration {
  inherit pkgs extraSpecialArgs;

  modules = [
    {
      home = {
        username = "vojta";
        homeDirectory = "/home/vojta";
      };
      xsession.profileExtra = ''
        xinput --set-prop "DELL0A20:00 0488:101A Touchpad" "libinput Tapping Enabled" 1
        xinput --set-prop "DELL0A20:00 0488:101A Touchpad" "libinput Natural Scrolling Enabled" 1
      '';
      user-modules = {
        common = {
          colorscheme = "gruvbox-dark";
          terminal = "WINIT_X11_SCALE_FACTOR=1 run-alacritty";
        };
        zsh.enable = true;
        alacritty.enable = true;
        emacs = {
          enable = true;
          pythonTabs = true;
        };
        autorandr.enable = true;
        dunst.enable = true;
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
              command = "polybar b0";
              notification = false;
            }
            {
              command = "picom -b";
              notification = false;
            }
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
            { command = "i3-msg 'workspace number 4; exec WINIT_X11_SCALE_FACTOR=1 run-alacritty; exec WINIT_X11_SCALE_FACTOR=1 run-alacritty'"; }
            { command = "slack"; }
            { command = "spotify-launcher"; }
          ];
        };
        mpd.enable = true;
        nixgl.enable = true;
        nodejs.enable = true;
        packages.enable = true;
        polybar = {
          enable = true;
          bar0Override = {
            monitor = "\${env:MONITOR:DP-1-2}";
            monitor-fallback = "\${env:MONITOR:eDP-1}";
            monitor-strict = true;
            font = [
              "Symbols\ Nerd\ Font:10;2"
              "Open Sans:pixelsize=11;2"
              "Source\ Han\ Sans:pixelsize=10;2"
            ];
            modules-right = "filesystem xkeyboard cpu memory backlight battery date powermenu";
          };
          bar1Override = {
            monitor = "\${env:MONITOR:DP-1-3}";
            monitor-strict = true;
          };
        };
        picom = {
          enable = true;
          service = false;
        };
        fonts.enable = true;
        rofi.enable = true;
        zathura.enable = true;
        gtk.enable = true;
      };
    }
  ] ++ import ./../../user-modules;
}
