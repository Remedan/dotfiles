{ ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  user-modules = {
    common.hidpi = true;
    nodejs.enable = true;
  };
}
