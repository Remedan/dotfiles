{ pkgs, ... }:
{
  home.packages = [
    pkgs.nixgl.auto.nixGLDefault
    (pkgs.writeShellScriptBin "run-alacritty" ''
      nixGL alacritty
    '')
  ];
}
