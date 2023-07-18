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
          polybarExtraSettings = {
            "b0" = {
              height = 27;
              fixed-center = true;
              monitor = "\${env:MONITOR:DP-0}";
              font = [
                "Symbols\ Nerd\ Font:10;2"
                "Open Sans:pixelsize=11;2"
                "Source\ Han\ Sans:pixelsize=10;2"
              ];
              modules-right = "filesystem xkeyboard cpu memory date powermenu";
            };
            "b1" = {
              monitor = "\${env:MONITOR:DP-2}";
            };
          };
          musicDirectory = "~/Network/Media/Audio";
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
          polybarExtraSettings = {
            "b0" = {
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
          terminal = "run-alacritty";
          pythonTabs = true;
          installKubectl = false;
          polybarExtraSettings = {
            "b0" = {
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
            "b1" = {
              monitor = "\${env:MONITOR:DP-1-3}";
              monitor-strict = true;
            };
          };
          musicDirectory = "~/Music";
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
