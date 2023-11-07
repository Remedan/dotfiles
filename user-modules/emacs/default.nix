{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.emacs;
in
{
  options.user-modules.emacs = {
    enable = mkEnableOption "Emacs";
    service = mkOption {
      type = types.bool;
      default = pkgs.stdenv.isLinux;
    };
    colorscheme = mkOption {
      type = types.str;
      default = config.user-modules.common.colorscheme;
    };
    pythonTabs = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home.file = {
      ".config/emacs/init.el".source = ./init.el;
      ".config/emacs/sakamoto.png".source = ./sakamoto.png;
      ".config/emacs/early-init.el".text = ''
        (setq colorscheme "${cfg.colorscheme}")
      '' + optionalString cfg.pythonTabs ''
        (setq python-tabs t)
      '';
    };
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      extraPackages = epkgs: with epkgs; [
        vterm
      ];
    };
    services.emacs.enable = cfg.service;
  };
}
