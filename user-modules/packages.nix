{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Core
    cmake
    fzf
    gcc
    gnumake
    gnupg
    playerctl
    ranger
    ripgrep
    rlwrap
    rsync
    steam-run
    tig

    # Dev
    awscli2
    blackbox
    krew
    kubectl
    postgresql
    terraform
    xxd
  ];
}
