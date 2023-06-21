{ pkgs, installKubectl ? true, ... }:

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
    steam-run
    tig

    # Dev
    awscli2
    blackbox
    postgresql
    terraform
    xxd

    # Python
    python310
    python310Packages.virtualenv
    python310Packages.virtualenvwrapper

    # Fonts
    iosevka
    source-code-pro
    source-sans-pro
    # Kubectl is optional since I sometimes need to install a specific older version
  ] ++ lib.optional installKubectl kubectl;
}
