{ ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  user-modules = {
    common.hidpi = true;
    hyprland.enable = false;
    zathura.enable = false;
    emacs.colorscheme = "doom-one";
    git.enable = false;
    kitty.colorscheme = "Argonaut";
  };
}
