{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.helios = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home = {
              username = "remedan";
              homeDirectory = "/home/remedan";
            };
            programs.git = {
                signing.key = "6C91735267F988F7E16BE32EA16152897E76E209";
                signing.signByDefault = true;
            };
          }
          ./modules/common.nix
          ./modules/zsh.nix
          ./modules/git-common.nix
          ./modules/git-personal.nix
        ];
      };

      homeConfigurations.rincewind = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home = {
              username = "remedan";
              homeDirectory = "/home/remedan";
              sessionVariables = {
                COLORSCHEME = "dracula";
              };
            };
	    xsession.enable = true;
          }
          ./modules/common.nix
          ./modules/packages.nix
          ./modules/zsh.nix
          ./modules/git-common.nix
          ./modules/git-personal.nix
          ./modules/emacs.nix
        ];
      };

      homeConfigurations.atuin = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home = {
              username = "vojta";
              homeDirectory = "/home/vojta";
              sessionVariables = {
                REM_LAMBDA_KUBERNETES = 1;
              };
              shellAliases = {
                tunnel = "***REMOVED***";
                ovpn = "***REMOVED***";
                squid = "PGPASSWORD=***REMOVED*** pgcli -U squid -d squid -h squid.int.quantlane.com -p 2080";
              };
            };
          }
          ./modules/common.nix
          ./modules/zsh.nix
          ./modules/git-common.nix
          ./modules/git-quantlane.nix
        ];
      };
    };
}
