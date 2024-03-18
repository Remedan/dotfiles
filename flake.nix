{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, nixgl, ... }:
    let
      mkPkgs = system: import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
      };
    in
    {
      formatter = builtins.listToAttrs (builtins.map
        (system: {
          name = system;
          value = (mkPkgs system).nixpkgs-fmt;
        }) [ "x86_64-linux" "aarch64-darwin" ]);

      nixosConfigurations = {
        weatherwax = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/weatherwax/system.nix ];
        };

        rincewind = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/rincewind/system.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
          ];
        };

        atuin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/atuin/system.nix
            nixos-hardware.nixosModules.dell-latitude-5520
          ];
        };
      };

      homeConfigurations = {
        "remedan@weatherwax" = import ./hosts/weatherwax/user.nix {
          inherit home-manager;
          pkgs = mkPkgs "x86_64-linux";
        };

        "remedan@rincewind" = import ./hosts/rincewind/user.nix {
          inherit home-manager;
          pkgs = mkPkgs "x86_64-linux";
        };

        "vojta@atuin" = import ./hosts/atuin/user.nix {
          inherit home-manager;
          pkgs = mkPkgs "x86_64-linux";
        };
      };
    };
}
