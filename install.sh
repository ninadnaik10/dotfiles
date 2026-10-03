#!/usr/bin/env bash
#
# Bootstrap a new machine with these dotfiles.
#
#   git clone https://github.com/ninadnaik10/dotfiles.git ~/dotfiles
#   ~/dotfiles/install.sh
#
# Safe to re-run: every step skips work that is already done.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/JetBrainsMono.zip"
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
FONT_NAME="JetBrainsMono Nerd Font"
FONT_SIZE="12"
NODE_VERSION="22"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==>\033[0m %s\n' "$*" >&2; }
has()  { command -v "$1" &>/dev/null; }

# ---------------------------------------------------------------------------
# System packages
# ---------------------------------------------------------------------------
install_packages() {
  local common=(git curl unzip zsh tmux neovim vim stow jq fontconfig wl-clipboard zoxide)

  if has dnf; then
    info "Installing packages with dnf"
    sudo dnf install -y "${common[@]}" make gcc patch zlib-devel bzip2 bzip2-devel \
      readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel libuuid-devel
  elif has apt-get; then
    info "Installing packages with apt"
    sudo apt-get update
    sudo apt-get install -y "${common[@]}" build-essential libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev \
      libxmlsec1-dev libffi-dev liblzma-dev
  elif has pacman; then
    info "Installing packages with pacman"
    sudo pacman -Syu --needed --noconfirm "${common[@]}" base-devel openssl zlib xz tk
  else
    warn "Unsupported package manager. Install manually: ${common[*]}"
  fi
}

# ---------------------------------------------------------------------------
# Shell: oh-my-zsh + plugins + starship
# ---------------------------------------------------------------------------
install_shell() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing oh-my-zsh"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  local autosuggest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  if [ ! -d "$autosuggest" ]; then
    info "Installing zsh-autosuggestions"
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$autosuggest"
  fi

  if ! has starship; then
    info "Installing starship"
    mkdir -p "$HOME/.local/bin"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
  fi

  local zsh_path
  zsh_path="$(command -v zsh)"
  if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$zsh_path" ]; then
    info "Changing default shell to zsh"
    chsh -s "$zsh_path" || warn "Could not change shell; run: chsh -s $zsh_path"
  fi
}

# ---------------------------------------------------------------------------
# Language toolchains referenced by .zshrc
# ---------------------------------------------------------------------------
install_toolchains() {
  if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    info "Installing nvm"
    local nvm_tag
    nvm_tag="$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r .tag_name)" || true
    PROFILE=/dev/null bash -c "$(curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_tag:-v0.40.3}/install.sh")"
  fi
  info "Installing Node $NODE_VERSION"
  # shellcheck disable=SC1091
  (set +eu; . "$HOME/.nvm/nvm.sh"; nvm install "$NODE_VERSION" >/dev/null)

  if [ ! -d "$HOME/.pyenv" ]; then
    info "Installing pyenv"
    curl -fsSL https://pyenv.run | bash
  fi

  if [ ! -f "$HOME/.deno/env" ]; then
    info "Installing deno"
    curl -fsSL https://deno.land/install.sh | sh -s -- -y --no-modify-path
  fi
}

# ---------------------------------------------------------------------------
# Symlink dotfiles with stow
# ---------------------------------------------------------------------------
link_dotfiles() {
  info "Linking dotfiles"
  # Make sure ~/.config is a real directory so stow links its children
  # instead of turning the whole of ~/.config into a symlink.
  mkdir -p "$HOME/.config"

  # Back up any real files that would block stow.
  local backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
  local conflicts
  conflicts="$(cd "$DOTFILES" && stow --no --verbose=0 --target="$HOME" . 2>&1 |
    sed -nE 's/.*existing target ([^ ]+) since.*/\1/p; s/.*existing target is neither a link nor a directory: (.+)/\1/p' |
    sort -u)" || true

  if [ -n "$conflicts" ]; then
    while IFS= read -r f; do
      [ -e "$HOME/$f" ] && [ ! -L "$HOME/$f" ] || continue
      mkdir -p "$backup/$(dirname "$f")"
      mv "$HOME/$f" "$backup/$f"
      warn "Backed up ~/$f -> $backup/$f"
    done <<< "$conflicts"
  fi

  (cd "$DOTFILES" && stow --restow --target="$HOME" .)
}

# ---------------------------------------------------------------------------
# tmux plugins
# ---------------------------------------------------------------------------
install_tmux_plugins() {
  local tpm="$HOME/.config/tmux/plugins/tpm"
  if [ ! -d "$tpm" ]; then
    info "Installing tmux plugin manager"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm"
  fi
  info "Installing tmux plugins"
  TMUX_PLUGIN_MANAGER_PATH="$HOME/.config/tmux/plugins/" "$tpm/bin/install_plugins" >/dev/null ||
    warn "tmux plugin install failed; press prefix + I inside tmux"
}

# ---------------------------------------------------------------------------
# JetBrains Mono Nerd Font
# ---------------------------------------------------------------------------
install_font() {
  if fc-list | grep "JetBrainsMono Nerd Font" >/dev/null; then
    info "JetBrainsMono Nerd Font already installed"
  else
    info "Installing JetBrainsMono Nerd Font"
    local tmp
    tmp="$(mktemp -d)"
    curl -fL --progress-bar -o "$tmp/font.zip" "$NERD_FONT_URL"
    mkdir -p "$FONT_DIR"
    unzip -oq "$tmp/font.zip" -d "$FONT_DIR" '*.ttf'
    rm -rf "$tmp"
    fc-cache -f "$FONT_DIR" >/dev/null
  fi

  set_terminal_font
}

set_terminal_font() {
  has gsettings || return 0
  local font="$FONT_NAME $FONT_SIZE"

  # Ptyxis (default terminal on Fedora 41+ / GNOME)
  if gsettings list-schemas 2>/dev/null | grep -x org.gnome.Ptyxis >/dev/null; then
    info "Setting Ptyxis font to $font"
    gsettings set org.gnome.Ptyxis use-system-font false
    gsettings set org.gnome.Ptyxis font-name "$font"
  fi

  # GNOME Terminal
  if gsettings list-schemas 2>/dev/null | grep -x org.gnome.Terminal.ProfilesList >/dev/null; then
    local profile
    profile="$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")"
    if [ -n "$profile" ]; then
      info "Setting GNOME Terminal font to $font"
      local path="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/"
      gsettings set "$path" use-system-font false
      gsettings set "$path" font "$font"
    fi
  fi
}

main() {
  install_packages
  install_shell
  install_toolchains
  link_dotfiles
  install_tmux_plugins
  install_font
  info "Done! Log out and back in (or run 'exec zsh') to start using your setup."
}

main "$@"
