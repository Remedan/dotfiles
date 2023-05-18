{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Core
    alacritty
    cmake
    fzf
    gcc
    gnumake
    gnupg
    ranger
    ripgrep
    rlwrap
    tig

    # Extra
    _1password
    _1password-gui

    # Dev
    awscli2
    blackbox
    kubectl
    postgresql
    terraform

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
