{ pkgs, home-manager }:

home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  modules = [
    {
      home = {
        username = "remedan";
        homeDirectory = "/Users/remedan";
      };
      user-modules = {
        common.colorscheme = "dracula";
        zsh.enable = true;
        emacs.enable = true;
      };
    }
  ] ++ import ./../../user-modules;
}
