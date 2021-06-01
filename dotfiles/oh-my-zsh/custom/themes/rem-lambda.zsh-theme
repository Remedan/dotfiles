local ret_status="%(?:%{$fg_bold[green]%}λ:%{$fg_bold[red]%}%? λ)%{$reset_color%}"
local host=""
if [ -n "$SSH_CLIENT" ]; then
    host="@%m"
fi
PROMPT='%{$fg[blue]%}%n%{$reset_color%}${host} %{$fg_bold[cyan]%}$(shrink_path -f)%{$reset_color%} $(git_prompt_info)${ret_status} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
