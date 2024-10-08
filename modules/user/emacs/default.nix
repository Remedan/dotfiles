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
      default = "doom-one";
    };
  };
  config = mkIf cfg.enable {
    xdg.configFile = {
      "emacs/init.el".source = ./init.el;
      "emacs/straight/versions/default.el".source = ./straight-lock.el;
      "emacs/sakamoto.png".source = ./sakamoto.png;
      "emacs/early-init.el".text = ''
        (setq package-enable-at-startup nil)
        (setq colorscheme "${cfg.colorscheme}")
      '';
    };
    programs.emacs = {
      enable = true;
      package = pkgs.emacs30-pgtk;
      extraPackages = epkgs: with epkgs; [
        vterm
      ];
    };
    services.emacs = {
      enable = cfg.service;
      startWithUserSession = "graphical"; # Fixes *ERROR*: Display :0 can’t be opened
    };
    # Emacs needs to have kitty's terminfo in env if it is started in terminal
    systemd.user.services.emacs.Service.Environment = mkIf
      (cfg.service && config.user-modules.kitty.enable)
      [ "TERMINFO=${pkgs.kitty}/lib/kitty/terminfo" ];
  };
}
