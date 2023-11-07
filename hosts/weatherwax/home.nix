{ pkgs, home-manager, extraSpecialArgs }:

home-manager.lib.homeManagerConfiguration {
  inherit pkgs extraSpecialArgs;

  modules = [
    {
      home = {
        username = "remedan";
        homeDirectory = "/home/remedan";
      };
      gtk = {
        enable = true;
        theme.name = "Adwaita";
        cursorTheme.name = "Adwaita";
        iconTheme.name = "Adwaita";
        gtk2.extraConfig = ''
          gtk-application-prefer-dark-theme=1
        '';
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
        };
      };
      user-modules = {
        common = {
          colorscheme = "selenized-dark";
          terminal = "alacritty";
        };
        zsh.enable = true;
        alacritty.enable = true;
        emacs.enable = true;
        dunst.enable = true;
        git.enable = true;
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
              command = "blueman-applet";
              notification = false;
            }
            {
              command = "systemctl --user import-environment"; # this fixes some applications (e.g. Firefox) being slow to start
              notification = false;
            }
          ];
        };
        mpd = {
          enable = true;
          musicDirectory = "~/Network/Media/Audio";
        };
        fonts.enable = true;
        packages.enable = true;
        picom.enable = true;
        polybar = {
          enable = true;
          secondBar = true;
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
