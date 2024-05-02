{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      nixosConfigurations = {
        weatherwax = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/weatherwax/system.nix ];
        };

        rincewind = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/rincewind/system.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
          ];
        };

        atuin = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/atuin/system.nix
            nixos-hardware.nixosModules.dell-latitude-5520
          ];
        };
      };

      homeConfigurations = {
        "remedan@weatherwax" = import ./hosts/weatherwax/user.nix {
          inherit pkgs home-manager;
        };

        "remedan@rincewind" = import ./hosts/rincewind/user.nix {
          inherit pkgs home-manager;
        };

        "vojta@atuin" = import ./hosts/atuin/user.nix {
          inherit pkgs home-manager;
        };
      };
    };
}
