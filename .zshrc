# Add useful directories to path
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.symfony/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Custom ls colors (better for bad colour vision)
eval `dircolors $HOME/.dir_colors`

# Set EDITOR to neovim if it's installed
if command -v nvim > /dev/null
then
    export EDITOR=nvim
fi

# Set up IBus
if command -v ibus-daemon > /dev/null
then
    export GTK_IM_MODULE="ibus"
    export QT_IM_MODULE="ibus"
    export XMODIFIERS="@im=ibus"
    ibus-daemon -drx
fi

# Useful aliases
alias sxiv='sxiv -a'
alias sudo='sudo -E'
alias ip='ip -c'
alias wine32='WINEARCH=win32 WINEPREFIX=~/.wine32 wine'

# Git aliases
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

# Set up virtualenvwrapper
if [ -f /usr/bin/virtualenvwrapper.sh ]
then
    export WORKON_HOME=~/.virtualenvs
    source /usr/bin/virtualenvwrapper.sh
fi
