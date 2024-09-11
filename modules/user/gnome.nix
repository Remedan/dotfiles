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
    home.packages = with pkgs; ([
      dconf-editor
      dconf2nix
      gnome-pomodoro
      gnome-tweaks
      smile
    ]) ++ (with pkgs.gnomeExtensions; [
      appindicator
      bluetooth-battery-meter
      caffeine
      dash-to-dock
      smile-complementary-extension
      tiling-assistant
    ]);
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
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
        ];
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
      "org/gnome/shell" = {
        enabled-extensions = [
          "Bluetooth-Battery-Meter@maniacx.github.com"
          "appindicatorsupport@rgcjonas.gmail.com"
          "caffeine@patapon.info"
          "dash-to-dock@micxgx.gmail.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "pomodoro@arun.codito.in"
          "smile-extension@mijorus.it"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
          "tiling-assistant@leleat-on-github"
        ];
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        edge-tiling = true;
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
    };
  };
}
