{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.user-modules.fonts;
in
{
  options.user-modules.fonts = {
    enable = mkEnableOption "fonts";
  };
  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      iosevka-bin
      source-code-pro
      source-sans-pro
      noto-fonts-emoji
      open-sans
      source-han-sans
      nerdfonts
    ];
    xdg.configFile."fontconfig/conf.d/20-no-embedded-bitmap.conf".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
        <match target="font">
          <edit name="embeddedbitmap" mode="assign">
            <bool>false</bool>
          </edit>
        </match>
      </fontconfig>
    '';
    xdg.configFile."fontconfig/conf.d/55-emoji-prepend.conf".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
        <match>
          <test name="family"><string>sans-serif</string></test>
          <edit mode="prepend" name="family" binding="weak"><string>Noto Color Emoji</string></edit>
        </match>

        <match>
          <test name="family"><string>serif</string></test>
          <edit mode="prepend" name="family" binding="weak"><string>Noto Color Emoji</string></edit>
        </match>

        <match>
          <test name="family"><string>Apple Color Emoji</string></test>
          <edit mode="prepend" name="family" binding="weak"><string>Noto Color Emoji</string></edit>
        </match>
      </fontconfig>
    '';
  };
}
