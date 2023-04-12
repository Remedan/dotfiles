{ pkgs, ... }:

{
  home.packages = with pkgs; [
    emacs
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
