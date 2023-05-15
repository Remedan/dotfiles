{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    alacritty
    awscli2
    blackbox
    cmake
    fzf
    fzy
    gcc
    gnumake
    gnupg
    kubectl
    postgresql
    ranger
    ripgrep
    rlwrap
    tig

    # Python
    python310
    python310Packages.virtualenv
    python310Packages.virtualenvwrapper

    # Fonts
    iosevka
    source-code-pro
    source-sans-pro
  ];
}
