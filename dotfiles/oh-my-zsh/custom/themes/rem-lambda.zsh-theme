local ret_status="%(?:%{$fg_bold[green]%}λ:%{$fg_bold[red]%}λ %?)"
PROMPT='${ret_status} %{$fg[cyan]%}%~/%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
