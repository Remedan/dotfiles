{ ... }:
{
  home = {
    username = "remedan";
    homeDirectory = "/home/remedan";
  };
  user-modules = {
    packages.categories.emulators = true;
    hyprland = {
      idleLock = false;
      nvidia = true;
      startup = [
        "solaar -w hide"
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] thunderbird"
        "[workspace 8 silent] steam"
        "[workspace 9 silent] spotify"
      ];
      workspaces = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-2, default:true"
        "5, monitor:DP-2"
        "6, monitor:DP-2"
        "7, monitor:DP-2"
        "8, monitor:DP-2"
        "9, monitor:DP-2"
        "10, monitor:DP-2"
      ];
    };
  };
}
