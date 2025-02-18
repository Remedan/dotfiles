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
      nerd-fonts.symbols-only
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.iosevka-term-slab
      noto-fonts-emoji
      open-sans
      source-code-pro
      source-han-sans
      source-sans-pro
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
