{ colorscheme, ... }:
let
  colorschemes = {
    "gruvbox-dark" = {
      primary = {
        background        = "#282828";
        foreground        = "#ebdbb2";
        bright_foreground = "#fbf1c7";
        dim_foreground    = "#a89984";
      };
      cursor = {
        text   = "CellBackground";
        cursor = "CellForeground";
      };
      vi_mode_cursor = {
        text   = "CellBackground";
        cursor = "CellForeground";
      };
      selection = {
        text       = "CellBackground";
        background = "CellForeground";
      };
      bright = {
        black   = "#928374";
        red     = "#fb4934";
        green   = "#b8bb26";
        yellow  = "#fabd2f";
        blue    = "#83a598";
        magenta = "#d3869b";
        cyan    = "#8ec07c";
        white   = "#ebdbb2";
      };
      normal = {
        black   = "#665c54";
        red     = "#cc241d";
        green   = "#98971a";
        yellow  = "#d79921";
        blue    = "#458588";
        magenta = "#b16286";
        cyan    = "#689d6a";
        white   = "#a89984";
      };
      dim = {
        black   = "#32302f";
        red     = "#9d0006";
        green   = "#79740e";
        yellow  = "#b57614";
        blue    = "#076678";
        magenta = "#8f3f71";
        cyan    = "#427b58";
        white   = "#928374";
      };
    };
    "selenized-dark" = {
      primary = {
        background = "0x103c48";
        foreground = "0xadbcbc";
      };
      normal = {
        black   = "0x184956";
        red     = "0xfa5750";
        green   = "0x75b938";
        yellow  = "0xdbb32d";
        blue    = "0x4695f7";
        magenta = "0xf275be";
        cyan    = "0x41c7b9";
        white   = "0x72898f";
      };
      bright = {
        black   = "0x2d5b69";
        red     = "0xff665c";
        green   = "0x84c747";
        yellow  = "0xebc13d";
        blue    = "0x58a3ff";
        magenta = "0xff84cd";
        cyan    = "0x53d6c7";
        white   = "0xcad8d9";
      };
    };
  };
in {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 5;
          y = 5;
        };
      };
      font = {
        normal = {
          family = "Iosevka Term";
          size = 11.0;
        };
      };
      colors = colorschemes.${colorscheme};
    };
  };
}
