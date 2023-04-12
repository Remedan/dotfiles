# Home Manager

[Home Manager Manual](https://nix-community.github.io/home-manager/)

## Installation

Set up `nix` and enable [flakes](https://nixos.wiki/wiki/Flakes). Then install thus

```bash
nix run <flake-uri>#homeConfigurations.<profile>.activationPackage
```

## Building new configuration

```bash
home-manager switch --flake '<flake-uri>#<profile>'
```

## Screenshot

![screenshot](screenshot.png)
