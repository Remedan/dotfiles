{ pkgs, colorscheme, ... }:
{
  services.emacs.enable = true;
  home.file = {
    ".config/emacs/init.el".source = ../dotfiles/config/emacs/init.el;
    ".config/emacs/sakamoto.png".source = ../dotfiles/config/emacs/sakamoto.png;
  };
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    extraConfig = ''
      (defun theme-name (name)
        (intern (concat "doom-"
                        (cond ((string= name "selenized-dark") "solarized-dark")
                              ((string= name "gruvbox-dark") "gruvbox")
                              (t name)))))
      (load-theme (theme-name "${colorscheme}") t)
    '';
    extraPackages = epkgs: [ epkgs.vterm ];
  };
}
