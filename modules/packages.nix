{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ranger
    gnumake
    cmake
    fzf
    tig
    gnupg

    python310
    python310Packages.virtualenvwrapper
  ];
}
