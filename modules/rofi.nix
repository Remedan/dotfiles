{ colorscheme, ... }:
{
  programs.rofi = {
    enable = true;
    font = "Open Sans 12";
    theme = colorscheme;
  };
  home.file = {
    ".config/rofi/dracula.rasi".source = ../dotfiles/config/rofi/dracula.rasi;
    ".config/rofi/nord.rasi".source = ../dotfiles/config/rofi/nord.rasi;
    ".config/rofi/selenized-dark.rasi".source = ../dotfiles/config/rofi/selenized-dark.rasi;
  };
}
