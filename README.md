# ~/dotfiles

Can be installed by cloning this repo into your home and running the `install.sh` script. The script will back up your old dotfiles. Use at your own risk.

The repo has different branches for the different computers I use. There's some stuff such as paths and monitor setup that you'll need to adapt to your environment.

## Screenshot

![screenshot](https://raw.githubusercontent.com/Remedan/dotfiles/master/screenshot.png)

## Key Components and Software

* [i3-gaps](https://github.com/Airblader/i3) + Polybar + Picom
    - OR Sway + Waybar
* kitty/alacritty + zsh
* Neovim
* Ranger
* Rofi
* dunst
* mpd + ncmpcpp
* sxiv, mpv, zathura
* redshift
* WeeChat

### Fonts

My two favourite programming fonts are [Iosevka](https://typeof.net/Iosevka/) and [Terminus](http://terminus-font.sourceforge.net/). I also use Font Awesome for a few icons in Polybar.

### Git user config

To keep my git user info from this repo I source it from `~/.gituser`. Git will complain if it doesn't exist. Example contents:

```
[user]
    name = "John Doe"
    email = "jd@example.org"
    signingkey = "ABC123DEF456"
```

### Zsh config

I usually have the [grml zsh config](https://grml.org/zsh/) installed in /etc,
which is why my .zshrc is rather short.

### Vim plugins

Plugins are managed via vim-plug. The install script sets this up.
