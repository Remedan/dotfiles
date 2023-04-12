{
  home.file.".config/oh-my-zsh/themes/rem-lambda.zsh-theme".text = ''
    local ret_status="%(?:%{$fg_bold[green]%}λ:%{$fg_bold[red]%}%? λ)%{$reset_color%}"
    local host=""
    if [ -n "$SSH_CLIENT" ]; then
        host="@%m"
    fi
    PROMPT='%{$fg[blue]%}%n%{$reset_color%}$host %{$fg_bold[cyan]%}$(shrink_path -f)%{$reset_color%} $(git_prompt_info)$ret_status '
    if [ -n "$REM_LAMBDA_KUBERNETES" ]; then
        RPROMPT="%{$fg[cyan]%}\$(kubectl config current-context).\$(kubectl config view --minify --output 'jsonpath={..namespace}')%{$reset_color%}"
    fi

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
  '';
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      theme = "rem-lambda";
      custom = "$HOME/.config/oh-my-zsh";
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
}
