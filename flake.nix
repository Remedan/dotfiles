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
      homeConfigurations.rincewind = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home = {
              username = "remedan";
              homeDirectory = "/home/remedan";
              stateVersion = "22.11";
            };
            programs.home-manager.enable = true;
          }
          ./modules/git-common.nix
          ./modules/git-personal.com
          ./hosts/rincewind.nix
        ];
      };

      homeConfigurations.atuin = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          {
            home = {
                username = "vojta";
                homeDirectory = "/home/vojta";
                stateVersion = "22.11";
            };
            programs.home-manager.enable = true;
          }
          ./modules/git-common.nix
          ./modules/git-quantlane.com
        ];
      };
    };
}
