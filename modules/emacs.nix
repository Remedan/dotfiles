{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.emacs;
in
{
  options.modules.emacs = {
    enable = mkEnableOption "Emacs";
    service = mkOption {
      type = types.bool;
      default = true;
    };
    pythonTabs = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home.file = {
      ".config/emacs/init.el".source = ../dotfiles/config/emacs/init.el;
      ".config/emacs/sakamoto.png".source = ../dotfiles/config/emacs/sakamoto.png;
      ".config/emacs/early-init.el".text = ''
        (setq colorscheme "${config.modules.common.colorscheme}")
      '' + optionalString cfg.pythonTabs ''
        (setq python-tabs t)
      '';
    };
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      extraPackages = epkgs: [ epkgs.vterm ];
    };
    services.emacs.enable = cfg.service;
  };
}
