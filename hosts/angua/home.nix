{ pkgs, home-manager, extraSpecialArgs }:

home-manager.lib.homeManagerConfiguration {
  inherit pkgs extraSpecialArgs;

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
