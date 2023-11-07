{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nix-search-cli.url = "github:peterldowns/nix-search-cli";
    nix-search-cli.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixgl, nix-search-cli, ... }:
    let
      mkPkgs = system: import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
        config.allowUnfree = true;
      };
      extraSpecialArgs = {
        inherit nix-search-cli;
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
          modules = [ ./hosts/weatherwax/nixos.nix ];
        };
      };

      homeConfigurations = {
        vimes = import ./hosts/weatherwax/home.nix {
          inherit home-manager extraSpecialArgs;
          pkgs = mkPkgs "x86_64-linux";
        };

        weatherwax = import ./hosts/weatherwax/home.nix {
          inherit home-manager extraSpecialArgs;
          pkgs = mkPkgs "x86_64-linux";
        };

        atuin = import ./hosts/atuin/home.nix {
          inherit home-manager extraSpecialArgs;
          pkgs = mkPkgs "x86_64-linux";
        };

        angua = import ./hosts/angua/home.nix {
          inherit home-manager extraSpecialArgs;
          pkgs = mkPkgs "aarch64-darwin";
        };
      };
    };
}
