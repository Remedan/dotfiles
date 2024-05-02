{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.common;
in
{
  options.user-modules.common = {
    colorscheme = mkOption {
      type = types.str;
      default = "gruvbox-dark";
    };
    terminal = mkOption {
      type = types.str;
      default = "kitty";
    };
    browser = mkOption {
      type = types.str;
      default = "firefox";
    };
  };
  config = mkMerge [
    {
      home = {
        stateVersion = "23.11";
        keyboard = {
          layout = "us,cz(qwerty)";
          options = [
            "grp:alt_shift_toggle"
            "caps:escape"
          ];
        };
      };
      programs.home-manager.enable = true;
      xdg.userDirs.enable = true;
      nix = {
        package = pkgs.nix;
        settings = {
          experimental-features = [ "nix-command" "flakes" ];
          extra-substituters = [
            "https://nixpkgs-python.cachix.org"
          ];
          extra-trusted-public-keys = [
            "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU="
          ];
        };
      };
      user-modules = {
        packages.enable = mkDefault true;
        shell.enable = mkDefault true;
        kitty.enable = mkDefault true;
        emacs.enable = mkDefault true;
        mpd.enable = mkDefault true;
        fonts.enable = mkDefault true;
        zathura.enable = mkDefault true;
        gtk.enable = mkDefault true;
        ssh.enable = mkDefault true;
        git.enable = mkDefault true;
        japanese.enable = mkDefault true;
      };
    }
  ];
}
