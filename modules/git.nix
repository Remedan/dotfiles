{
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      push.autoSetupRemote = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
    };

    userName = "Vojtěch Balák";
    userEmail = "vojtech@balak.me";
  };
}
