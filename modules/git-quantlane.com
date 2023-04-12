{
  programs.git = {
    userName = "Vojtěch Balák";
    userEmail = "***REMOVED***";
    signing.key = "***REMOVED***";
    signing.signByDefault = true;
  };
}
