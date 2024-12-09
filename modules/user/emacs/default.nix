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

    # Since the Emacs pgtk packages sets the wmclass to "emacs" (with lower-case e) we need to create
    # a new .desktop file that has a matching StartupWMCLass for Gnome to recognize the window.
    # Mostly taken from: https://github.com/nix-community/home-manager/blob/master/modules/services/emacs.nix#L19
    xdg.desktopEntries = {
      emacsclient = {
        name = "Emacs Client";
        exec = "${config.programs.emacs.package}/bin/emacsclient -c %F";
        icon = "emacs";
        comment = "Edit text";
        genericName = "Text Editor";
        mimeType = [ "text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
        categories = [ "Development" "TextEditor" ];
        settings = {
          Keywords = "Text;Editor";
          StartupWMClass = "emacs";
        };
      };
    };
  };
}
