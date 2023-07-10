{ ... }:
{
  programs.autorandr = {
    enable = true;
    profiles = {
      "mobile" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0030e48d0600000000001e0104951f1178e2adf5985e598b261c5054000000010101010101010101010101010101012e3680a070381f403020350035ae1000001a582b80a070381f403020350035ae1000001a000000fe00304858434b803134305746480a000000000000413199001000000a010a20200082";
        };
        config = {
          eDP-1 = {
            enable = true;
            crtc = 0;
            primary = true;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.02";
          };
        };
        hooks.postswitch = ''
            setxkbmap -layout 'us,cz(qwerty)' -option 'grp:alt_shift_toggle' -option 'caps:escape'

            polybar-msg cmd quit
            sleep 1
            polybar b0 &
        '';
      };
      "office" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0030e48d0600000000001e0104951f1178e2adf5985e598b261c5054000000010101010101010101010101010101012e3680a070381f403020350035ae1000001a582b80a070381f403020350035ae1000001a000000fe00304858434b803134305746480a000000000000413199001000000a010a20200082";
          DP-1-2 = "00ffffffffffff0010acdba04c345434191a0104a5351e783a0565a756529c270f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff0043573659373636473454344c0a000000fc0044454c4c205032343137480a20000000fd00384c1e5311010a202020202020001b";
          DP-1-3 = "00ffffffffffff0010acdba042343437091c0104a5351e783a0565a756529c270f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff004357365937383252373434420a000000fc0044454c4c205032343137480a20000000fd00384c1e5311010a202020202020006e";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-1-2 = {
            enable = true;
            crtc  = 0;
            primary = true;
            mode  = "1920x1080";
            position = "0x0";
            rate  = "60.00";
          };
          DP-1-3 = {
            enable = true;
            crtc = 2;
            mode  = "1920x1080";
            position = "1920x0";
            rate = "60.00";
          };
        };
        hooks.postswitch = ''
            setxkbmap -layout 'us,cz(qwerty)' -option 'grp:alt_shift_toggle' -option 'caps:escape' 

            for i in {1..3}; do
                i3-msg '[workspace="'$i'"]' move workspace to output DP-1-2
            done
            for i in {4..10}; do
                i3-msg '[workspace="'$i'"]' move workspace to output DP-1-3
            done

            polybar-msg cmd quit
            sleep 1
            polybar b0 &
            polybar b1 &
        '';
      };
      "home" = {
        fingerprint = {
          eDP-1 = "00ffffffffffff0030e48d0600000000001e0104951f1178e2adf5985e598b261c5054000000010101010101010101010101010101012e3680a070381f403020350035ae1000001a582b80a070381f403020350035ae1000001a000000fe00304858434b803134305746480a000000000000413199001000000a010a20200082";
          DP-1-2  = "00ffffffffffff004f2e00304e61bc002b170104a50000782aa2d0ac5130b425105054a54b00d1c00101818001010101010101010101641900404100263018883600122221000019000000fd003b471e6d10010a202020202020000000fc004e6f6e2d506e500a2020202020000000fe000a2020202020202020202020200095";
          DP-1-3  = "00ffffffffffff004f2e00304e61bc002b170104a50000782aa2d0ac5130b425105054a54b00d1c00101818001010101010101010101641900404100263018883600122221000019000000fd003b471e6d10010a202020202020000000fc004e6f6e2d506e500a2020202020000000fe000a2020202020202020202020200095";
        };
        config = {
          eDP-1 = {
            enable = false;
          };
          DP-1-2 = {
            enable = true;
            crtc  = 0;
            primary = true;
            mode  = "1920x1080";
            position = "0x0";
            rate  = "60.00";
          };
          DP-1-3 = {
            enable = true;
            crtc = 2;
            mode  = "1920x1080";
            position = "1920x0";
            rate = "60.00";
          };
        };
        hooks.postswitch = ''
          setxkbmap -layout 'us,cz(qwerty)' -option 'grp:alt_shift_toggle' -option 'caps:escape' 

          for i in {1..3}; do
              i3-msg '[workspace="'$i'"]' move workspace to output DP-1-2
          done
          for i in {4..10}; do
              i3-msg '[workspace="'$i'"]' move workspace to output DP-1-3
          done

          polybar-msg cmd quit
          sleep 1
          polybar b0 &
          polybar b1 &
        '';
      };
    };
  };
}
