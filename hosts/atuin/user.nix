{ ... }:
{
  home = {
    username = "vojta";
    homeDirectory = "/home/vojta";
  };
  user-modules = {
    common.hidpi = true;
    hyprland = {
      startup = [
        "birdtray"
        "solaar -w hide"
        "jetbrains-toolbox"
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] thunderbird"
        "[workspace 3 silent] obsidian"
        "[workspace 4 silent] kitty"
        "[workspace 4 silent] kitty"
        "[workspace 5 silent] emacsclient -c"
        "[workspace 8 silent] slack"
        "[workspace 9 silent] spotify"
      ];
      workspaces = [
        "1, monitor:DP-4, default:true"
        "2, monitor:DP-4"
        "3, monitor:DP-4"
        "4, monitor:DP-5, default:true"
        "5, monitor:DP-5"
        "6, monitor:DP-5"
        "7, monitor:DP-5"
        "8, monitor:DP-5"
        "9, monitor:DP-5"
        "10, monitor:DP-5"
      ];
    };
    emacs.colorscheme = "doom-one";
    git.enable = false;
  };
}
