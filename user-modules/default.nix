{ lib, ... }:
[
  ./alacritty
  ./autorandr.nix
  ./common.nix
  ./dunst.nix
  ./emacs
  ./fonts.nix
  ./git.nix
  ./i3
  ./mpd.nix
  ./nixgl.nix
  ./nodejs.nix
  ./packages.nix
  ./picom.nix
  ./polybar.nix
  ./rofi
  ./zathura.nix
  ./zsh.nix
] ++ lib.optional (builtins.pathExists ./local.nix) ./local.nix
