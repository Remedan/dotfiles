{ pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty
    awscli2
    cmake
    fzf
    gcc
    gnumake
    gnupg
    kubectl
    postgresql
    ranger
    ripgrep
    tig

    # Python
    python310
    python310Packages.virtualenv
    python310Packages.virtualenvwrapper

    # Fonts
    source-code-pro
    source-sans-pro
  ];
}
