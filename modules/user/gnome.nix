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
    home.packages = with pkgs; [
      dconf-editor
      gnome-pomodoro
      gnome-tweaks
      smile

      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.dash-to-dock
      gnomeExtensions.smile-complementary-extension
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
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
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
        name = "Open Terminal";
      };
      "org/gnome/shell" = {
        enabled-extensions = [
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "pomodoro@arun.codito.in"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
          "caffeine@patapon.info"
          "dash-to-dock@micxgx.gmail.com"
          "appindicatorsupport@rgcjonas.gmail.com"
          "smile-extension@mijorus.it"
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
