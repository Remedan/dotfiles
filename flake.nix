{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixgl, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ nixgl.overlay ];
        config.allowUnfree = true;
      };
    in
    {
      formatter.${pkgs.system} = pkgs.nixpkgs-fmt;
      homeConfigurations.vimes = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          colorscheme = "selenized-dark";
          terminal = "run-alacritty";
          pythonTabs = false;
          installKubectl = true;
          mpdOverrides = {
            musicDirectory = "~/Network/Media/Audio";
          };
          polybarOverride = {
            settings."bar/b0" = {
              monitor = "\${env:MONITOR:DP-0}";
            };
            settings."bar/b1" = {
              monitor = "\${env:MONITOR:DP-2}";
            };
          };
          i3 = {
            override = {
              config.workspaceOutputAssign =
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
            };
            startup = [
              {
                command = "xrandr --output DP-2 --mode 1920x1080 --rate 144.00 --output DP-0 --mode 1920x1080 --rate 144.00 --left-of DP-4 --primary";
                notification = false;
              }
              {
                command = "polybar b1";
                notification = false;
              }
              {
                command = "blueman-applet";
                notification = false;
              }
            ];
          };
        };

        modules = [
          {
            home = {
              username = "remedan";
              homeDirectory = "/home/remedan";
            };
            xsession.profileExtra = ''
              nvidia-settings -l
            '';
          }
          ./modules/alacritty.nix
          ./modules/common.nix
          ./modules/dunst.nix
          ./modules/emacs.nix
          ./modules/fonts.nix
          ./modules/git.nix
          ./modules/i3.nix
          ./modules/mpd.nix
          ./modules/nixgl.nix
          ./modules/packages.nix
          ./modules/picom.nix
          ./modules/polybar.nix
          ./modules/rofi.nix
          ./modules/zathura.nix
          ./modules/zsh.nix
        ];
      };

      homeConfigurations.rincewind = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          colorscheme = "dracula";
          terminal = "alacritty";
          polybarOverride = {
            settings."bar/b0" = {
              height = 25;
              fixed-center = false;
              font = [
                "Symbols\ Nerd\ Font:14;2"
                "Open Sans:pixelsize=14;2"
                "Source\ Han\ Sans:pixelsize=16;2"
              ];
              modules-right = "filesystem xkeyboard cpu memory backlight battery date powermenu";
            };
          };
          i3 = {
            override = {
              config.gaps.inner = 6;
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
            ];
          };
        };

        modules = [
          {
            home = {
              username = "remedan";
              homeDirectory = "/home/remedan";
            };
            xsession.profileExtra = ''
              xinput --set-prop "Elan Touchpad" "libinput Tapping Enabled" 1
              xinput --set-prop "Elan Touchpad" "libinput Natural Scrolling Enabled" 1
            '';
          }
          ./modules/alacritty.nix
          ./modules/common.nix
          ./modules/emacs.nix
          ./modules/git.nix
          ./modules/i3.nix
          ./modules/packages.nix
          ./modules/polybar.nix
          ./modules/rofi.nix
          ./modules/zsh.nix
        ];
      };

      homeConfigurations.atuin = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          colorscheme = "gruvbox-dark";
          terminal = "WINIT_X11_SCALE_FACTOR=1 run-alacritty";
          browser = "vivaldi-stable";
          pythonTabs = true;
          installKubectl = false;
          mpdOverrides = { };
          polybarOverride = {
            settings."bar/b0" = {
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
            settings."bar/b1" = {
              monitor = "\${env:MONITOR:DP-1-3}";
              monitor-strict = true;
            };
          };
          i3 = {
            override = {
              config.assigns = {
                "1" = [{ class = "firefox"; } { class = "vivaldi-stable"; }];
                "2" = [{ class = "thunderbird"; }];
                "3" = [{ class = "obsidian"; }];
                "8" = [{ class = "Slack"; }];
                "9" = [{ class = "Spotify"; }];
              };
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
              { command = "vivaldi-stable"; }
              { command = "thunderbird"; }
              { command = "obsidian"; }
              { command = "i3-msg 'workspace number 4; exec WINIT_X11_SCALE_FACTOR=1 run-alacritty; exec WINIT_X11_SCALE_FACTOR=1 run-alacritty'"; }
              { command = "slack"; }
              { command = "spotify-launcher"; }
            ];
          };
        };

        modules = [
          {
            home = {
              username = "vojta";
              homeDirectory = "/home/vojta";
              sessionVariables = {
                REM_LAMBDA_KUBERNETES = 1;
              };
            };
            xsession.profileExtra = ''
              xinput --set-prop "DELL0A20:00 0488:101A Touchpad" "libinput Tapping Enabled" 1
              xinput --set-prop "DELL0A20:00 0488:101A Touchpad" "libinput Natural Scrolling Enabled" 1
            '';
          }
          ./modules/alacritty.nix
          ./modules/autorandr.nix
          ./modules/common.nix
          ./modules/dunst.nix
          ./modules/emacs.nix
          ./modules/fonts.nix
          ./modules/i3.nix
          ./modules/mpd.nix
          ./modules/nixgl.nix
          ./modules/nodejs.nix
          ./modules/packages.nix
          ./modules/picom.nix
          ./modules/polybar.nix
          ./modules/rofi.nix
          ./modules/zathura.nix
          ./modules/zsh.nix
        ] ++ pkgs.lib.optional (builtins.pathExists ./modules/quantlane.nix) ./modules/quantlane.nix;
      };
    };
}
