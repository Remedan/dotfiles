{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      nodejs
    ];
    file.".npmrc".text = ''
      prefix=.npm-global
    '';
    sessionPath = [
      "$HOME/.npm-global/bin"
    ];
  };
}
