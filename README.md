# Dotfiles

This repo contains all of my dotfiles

## Setup on a new machine

```
git clone https://github.com/ninadnaik10/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` is safe to re-run. It:

- installs packages (zsh, tmux, neovim, vim, stow, zoxide, …) via dnf, apt or pacman
- installs oh-my-zsh, zsh-autosuggestions, starship and sets zsh as the login shell
- installs nvm (+ Node 22), pyenv and deno, which `.zshrc` expects
- symlinks the dotfiles into `~` with `stow`, backing up conflicting files to `~/.dotfiles-backup/`
- installs tmux plugins (tpm)
- installs JetBrainsMono Nerd Font and sets it as the Ptyxis / GNOME Terminal font

To only re-link the dotfiles: `cd ~/dotfiles && stow .`
