{ pkgs, installKubectl, ... }:

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
    rsync
    tig

    # Dev
    awscli2
    blackbox
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
  ] ++ lib.optional installKubectl kubectl;
}
