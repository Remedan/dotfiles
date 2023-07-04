{
  home = {
    stateVersion = "23.05";
    keyboard = {
      layout = "us,cz(qwerty)";
      options = [
        "grp:alt_shift_toggle"
        "caps:escape"
      ];
    };
  };
  programs.home-manager.enable = true;
  xsession.enable = true;
  xdg.userDirs.enable = true;
}
