{
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      push.autoSetupRemote = true;
    };
  };
}
