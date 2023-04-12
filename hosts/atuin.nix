{ config, pkgs, ... }:

{
  home.username = "remedan";
  home.homeDirectory = "/home/remedan";

  home.stateVersion = "22.11"; # Do not change without checking release notes

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Vojtěch Balák";
    userEmail = "***REMOVED***";
    signing.signByDefault = true;
    signing.key = "***REMOVED***";
    lfs.enable = true;
  };
}
