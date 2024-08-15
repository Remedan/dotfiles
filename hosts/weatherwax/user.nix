{ ... }:
{
  home = {
    username = "remedan";
    homeDirectory = "/home/remedan";
  };
  user-modules = {
    packages.categories.emulators = true;
    emacs.colorscheme = "doom-one";
    kitty.colorscheme = "Argonaut";
  };
}
