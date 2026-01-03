# My Dotfiles

Managed via a Bare Git Repository. This setup allows tracking files in the `$HOME` 
directory without symlink clutter.

## Setup

1. **Clone the repo:**  
    `git clone --bare https://github.com/AdamVeazey/dotfiles.git $HOME/.cfg`

1. **Define config alias for initial session:**  
    `alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`

1. **Deploy the files:**  
   `config checkout`  
   *Note: If there are conflicting default files (like .bashrc), move them out of the way first.*

1. **Silence the noise:**  
   `config config --local status.showUntrackedFiles no`

## Requirements

`sudo pacman -S zsh wezterm nvim fzf ttf-inconsolata-nerd`

- zsh
- ttf-inconsolata-nerd 
- wezterm
- fzf
- nvim
