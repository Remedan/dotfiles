{ ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  user-modules = {
    common.hidpi = true;
    emacs.colorscheme = "doom-one";
    git.enable = false;
    kitty.colorscheme = "Argonaut";
  };
}
