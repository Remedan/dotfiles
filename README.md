# Home Manager and NixOS

<img src="assets/nix-snowflake.svg" alt="Nix snowflake" width="200">

[Home Manager Manual](https://nix-community.github.io/home-manager/)

## Installation

Clone this repo to `~/.config/home-manager` and then run:

```bash
nix --extra-experimental-features 'nix-command flakes' run home-manager/master -- init --switch
```

## Building a new Home Manager configuration

```bash
home-manager switch
```

## Building a new NixOS configuration

```bash
sudo nixos-rebuild switch --flake '$HOME#<profile>'
```
