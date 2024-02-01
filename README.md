# Home Manager and NixOS

<img src="assets/nix-snowflake.svg" alt="Nix snowflake" width="200">

[Home Manager Manual](https://nix-community.github.io/home-manager/)

## Installation

```bash
nix --extra-experimental-features 'nix-command flakes' run <flake-uri>#homeConfigurations.<profile>.activationPackage
```

## Building a new Home Manager configuration

```bash
home-manager switch --flake '<flake-uri>#<profile>'
```

## Building a new NixOS configuration

```bash
sudo nixos-rebuild switch --flake '<flake-uri>#<profile>'
```
