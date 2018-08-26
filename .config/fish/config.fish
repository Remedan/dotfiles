if test -d ~/scripts
    set -x PATH $PATH ~/scripts
end
if command --search ruby > /dev/null
    set -x PATH $PATH (ruby -e 'print Gem.user_dir')/bin
end

if command --search nvim > /dev/null
    set -x EDITOR nvim
end

# enable colours in man pages
set -x LESS_TERMCAP_mb \e'[01;31m'
set -x LESS_TERMCAP_md \e'[01;31m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_se \e'[0m'
set -x LESS_TERMCAP_so \e'[01;44;33m'
set -x LESS_TERMCAP_ue \e'[0m'
set -x LESS_TERMCAP_us \e'[01;32m'

if command --search ibus-daemon > /dev/null
    set -x GTK_IM_MODULE "ibus"
    set -x XMODIFIERS "@im=ibus"
    set -x QT_IM_MODULE "ibus"
    ibus-daemon -drx
end

set fish_greeting

alias sxiv "sxiv -a"
alias sudo "sudo -E"
alias time "time -p"
alias ip "ip -c"

abbr -a gs git status
abbr -a ga git add
abbr -a gb git branch
abbr -a gc git commit
abbr -a gd git diff
abbr -a gdc git diff --cached
abbr -a go git checkout
abbr -a gh git hist
abbr -a gp git pull
abbr -a gu git push
abbr -a gm git merge
abbr -a gl git log

function sudo!!
    eval sudo $history[1]
end
