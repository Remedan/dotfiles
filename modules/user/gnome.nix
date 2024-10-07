{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.gnome;
in
{
  options.user-modules.gnome = {
    enable = mkEnableOption "Gnome";
  };
  config = mkIf cfg.enable {
    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        {
          package = pkgs.gnome-shell-extensions;
          id = "drive-menu@gnome-shell-extensions.gcampax.github.com";
        }
        {
          package = pkgs.gnome-shell-extensions;
          id = "system-monitor@gnome-shell-extensions.gcampax.github.com";
        }
        { package = appindicator; }
        { package = bluetooth-battery-meter; }
        { package = caffeine; }
        { package = dash-to-dock; }
        { package = gsconnect; }
        { package = search-light; }
        { package = smile-complementary-extension; }
        { package = tiling-assistant; }
      ];
    };
    home.packages = with pkgs; [
      dconf-editor
      dconf2nix
      gnome-tweaks
      smile
    ];
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
      };
      "org/gnome/desktop/wm/preferences" = {
        focus-mode = "mouse";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = genList (n: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString n}/") 5;
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Shift><Control>space";
        command = "1password --quick-access";
        name = "1Password Quick Access";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>Return";
        command = "kitty";
        name = "Terminal";
      };
      "org/gnome/settings-daemon/plugins/media-keysg/custom-keybindings/custom2" = {
        binding = "<Super>period";
        command = "smile";
        name = "Smile";
      };
      "org/gnome/settings-daemon/plugins/media-keysg/custom-keybindings/custom3" = {
        binding = "<Super>e";
        command = "emacsclient -c";
        name = "Emacs";
      };
      "org/gnome/settings-daemon/plugins/media-keysg/custom-keybindings/custom4" = {
        binding = "<Shift><Super>e";
        command = "emacsclient -ce '(full-calc)'";
        name = "Emacs Calc";
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        edge-tiling = true;
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
      "org/gnome/shell/extensions/search-light" = {
        background-color = lib.hm.gvariant.mkTuple [ 0.0 0.0 0.0 0.6 ];
        border-radius = 3.0;
        shortcut-search = [ "<Super>d" ];
      };
      "org/gnome/gnome-system-monitor" = {
        # Don't divide cpu usage by cpu count
        solaris-mode = false;
      };
    };
  };
}
