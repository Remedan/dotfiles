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
        zsh.enable = true;
        emacs.enable = true;
      };
    }
  ] ++ import ./../../modules/user;
}
