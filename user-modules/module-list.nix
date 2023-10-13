{ lib, ... }:
[
  ./alacritty.nix
  ./autorandr.nix
  ./common.nix
  ./dunst.nix
  ./emacs.nix
  ./fonts.nix
  ./git.nix
  ./i3.nix
  ./mpd.nix
  ./nixgl.nix
  ./nodejs.nix
  ./packages.nix
  ./picom.nix
  ./polybar.nix
  ./rofi.nix
  ./zathura.nix
  ./zsh.nix
] ++ lib.optional (builtins.pathExists ./local.nix) ./local.nix
