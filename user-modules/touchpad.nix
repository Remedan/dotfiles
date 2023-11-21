{ config, lib, ... }:
with lib;

let
  cfg = config.user-modules.touchpad;
in
{
  options.user-modules.touchpad = {
    enable = mkEnableOption "touchpad";
    deviceName = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    xsession.profileExtra = ''
      xinput --set-prop "${cfg.deviceName}" "libinput Tapping Enabled" 1
      xinput --set-prop "${cfg.deviceName}" "libinput Natural Scrolling Enabled" 1
    '';
    xdg.configFile."libinput-gestures.conf".text = ''
      gesture swipe right 3 i3-msg workspace prev
      gesture swipe left 3 i3-msg workspace next
    '';
  };
}
