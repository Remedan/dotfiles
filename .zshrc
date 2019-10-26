eval `dircolors $HOME/.dir_colors`

if [ -d $HOME/scripts ]
then
    export PATH="$PATH:$HOME/scripts"
fi

if command -v nvim > /dev/null
then
    export EDITOR=nvim
fi

if command -v ibus-daemon > /dev/null
then
    export GTK_IM_MODULE="ibus"
    export XMODIFIERS="@im=ibus"
    export QT_IM_MODULE="ibus"
    ibus-daemon -drx
fi

alias sxiv='sxiv -a'
alias sudo='sudo -E'
alias ip='ip -c'

alias gs='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gdc='git diff --cached'
alias go='git checkout'
alias gh='git hist'
alias gp='git pull'
alias gu='git push'
alias gm='git merge'
alias gl='git log'
