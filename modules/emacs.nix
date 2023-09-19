{ pkgs, colorscheme, pythonTabs ? false, ... }:
{
  services.emacs.enable = true;
  home.file = {
    ".config/emacs/init.el".source = ../dotfiles/config/emacs/init.el;
    ".config/emacs/sakamoto.png".source = ../dotfiles/config/emacs/sakamoto.png;
    ".config/emacs/early-init.el".text = ''
      (setq colorscheme "${colorscheme}")
    '' + pkgs.lib.optionalString pythonTabs ''
      (setq python-tabs t)
    '';
  };
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    extraPackages = epkgs: [ epkgs.vterm ];
  };
}
