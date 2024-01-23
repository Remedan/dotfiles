{ config, lib, ... }:
with lib;
let
  cfg = config.user-modules.zsh;
in
{
  options.user-modules.zsh = {
    enable = mkEnableOption "zsh";
  };
  config = mkIf cfg.enable {
    home = {
      sessionPath = [
        "$HOME/.local/bin"
        "$HOME/.krew/bin"
      ];
      sessionVariables = {
        EDITOR = if config.user-modules.emacs.service then "emacsclient -nw" else "emacs -nw";
      };
      shellAliases = {
        e = "eval \"$EDITOR\"";
        E = "sudoedit";
        ip = "ip -c";
        sxiv = "sxiv -a";
        mkvenv = "mkvirtualenv `basename $PWD`";
        rmvenv = "rmvirtualenv `basename $PWD`";
      };
    };
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "direnv"
          "docker"
          "docker-compose"
          "fzf"
          "git"
          "kubectl"
          "pip"
          "shrink-path"
          "virtualenvwrapper"
        ];
      };
    };
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        right_format = "$kubernetes";
        directory = {
          truncate_to_repo = false;
        };
        kubernetes = {
          disabled = false;
          format = "[$symbol$context( \\($namespace\\))]($style)";
        };
      };
    };
  };
}
