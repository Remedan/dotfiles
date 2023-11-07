{ pkgs, home-manager, extraSpecialArgs }:

home-manager.lib.homeManagerConfiguration {
  inherit pkgs extraSpecialArgs;

  modules = [
    {
      home = {
        username = "remedan";
        homeDirectory = "/home/remedan";
      };
      xsession.profileExtra = ''
        nvidia-settings -l
      '';
      user-modules = {
        common = {
          colorscheme = "selenized-dark";
          terminal = "run-alacritty";
        };
        zsh.enable = true;
        alacritty.enable = true;
        emacs.enable = true;
        dunst.enable = true;
        git = {
          enable = true;
          nixos = false;
        };
        i3 = {
          enable = true;
          workspaceOutput =
            map
              (number: {
                workspace = toString number;
                output = "DP-0";
              })
              (pkgs.lib.range 1 3)
            ++
            map
              (number: {
                workspace = toString number;
                output = "DP-2";
              })
              (pkgs.lib.range 4 10);
          startup = [
            {
              command = "xrandr --output DP-2 --mode 1920x1080 --rate 144.00 --output DP-0 --mode 1920x1080 --rate 144.00 --left-of DP-4 --primary";
              notification = false;
            }
            {
              command = "polybar b0";
              notification = false;
            }
            {
              command = "polybar b1";
              notification = false;
            }
            {
              command = "picom -b";
              notification = false;
            }
            {
              command = "blueman-applet";
              notification = false;
            }
          ];
        };
        mpd = {
          enable = true;
          musicDirectory = "~/Network/Media/Audio";
        };
        nixgl.enable = true;
        fonts.enable = true;
        packages.enable = true;
        picom = {
          enable = true;
          service = false;
        };
        polybar = {
          enable = true;
          bar0Override = {
            monitor = "\${env:MONITOR:DP-0}";
          };
          bar1Override = {
            monitor = "\${env:MONITOR:DP-2}";
          };
        };
        rofi.enable = true;
        zathura.enable = true;
      };
    }
  ] ++ import ./../../user-modules;
}
