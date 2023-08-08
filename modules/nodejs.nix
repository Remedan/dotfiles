{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      nodejs
    ];
    file.".npmrc".text = ''
      prefix = ''${HOME}/.npm-global
    '';
    sessionPath = [
      "$HOME/.npm-global/bin"
    ];
  };
}
