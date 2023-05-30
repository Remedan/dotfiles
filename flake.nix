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
      homeConfigurations.helios = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          colorscheme = "selenized-dark";
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
            programs.git = {
              signing.key = "6C91735267F988F7E16BE32EA16152897E76E209";
              signing.signByDefault = true;
            };
          }
          ./modules/common.nix
          ./modules/zsh.nix
          ./modules/nixgl.nix
          ./modules/alacritty.nix
          ./modules/git.nix
        ];
      };

      homeConfigurations.rincewind = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          colorscheme = "dracula";
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
          ./modules/common.nix
          ./modules/packages.nix
          ./modules/zsh.nix
          ./modules/git.nix
          ./modules/emacs.nix
          ./modules/i3.nix
          ./modules/alacritty.nix
          ./modules/rofi.nix
          ./modules/polybar.nix
        ];
      };

      homeConfigurations.atuin = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          colorscheme = "gruvbox-dark";
          pythonTabs = true;
          installKubectl = false;
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
          ./modules/common.nix
          ./modules/packages.nix
          ./modules/zsh.nix
          ./modules/nixgl.nix
          ./modules/alacritty.nix
          ./modules/nodejs.nix
          ./modules/emacs.nix
        ] ++ pkgs.lib.optional (builtins.pathExists ./modules/quantlane.nix) ./modules/quantlane.nix;
      };
    };
}
