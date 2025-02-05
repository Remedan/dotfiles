{ ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  user-modules = {
    common.hidpi = true;
    git.enable = false;
    emacs.doom = true;
  };
}
