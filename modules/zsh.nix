{ config, lib, ... }:
with lib;
let
  cfg = config.modules.zsh;
in
{
  options.modules.zsh = {
    enable = mkEnableOption "zsh";
  };
  config = mkIf cfg.enable {
    home = {
      sessionPath = [
        "$HOME/.local/bin"
        "$HOME/.krew/bin"
      ];
      sessionVariables = {
        EDITOR = "emacsclient -nw";
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
      initExtra = ''
        # Needed for YubiKey + ssh
        export GPG_TTY="$(tty)"
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        gpgconf --launch gpg-agent
      '';
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
        directory = {
          truncate_to_repo = false;
        };
      };
    };
  };
}
