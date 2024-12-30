# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
  zsh-autosuggestions
)
# Enable auto-suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# Bind accept suggestion to right arrow key
bindkey '^ ' autosuggest-accept

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Tmux auto-attach
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# Aliases
alias sem7='cd "/run/media/ninad/Primary Storage HDD/Sem 7"'
alias ds='sudo systemctl start docker'
alias dcu='docker compose up -d'
alias sd='sudo systemctl start docker'
alias z2='sudo ~/scripts/a2dp.sh'
alias prog='cd /mnt/sda5/Programming'
alias zshrc='vim ~/dotfiles/.zshrc'
alias ..='cd ..'
alias clr='clear'
alias g='git'
alias v='vim'
alias tm='TERM=xterm-256color tmux -u'
alias ll='ls -lah --color=auto'
alias clip=wl-copy

# History configuration
HISTSIZE=1000
SAVEHIST=2000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY

# Enable command auto-correction
setopt CORRECT

# Enable extended globbing
setopt EXTENDED_GLOB

# Load colors
autoload -U colors && colors

# Starship prompt
eval "$(starship init zsh)"

# Path exports
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$HOME/cmdline-tools/bin"
export PATH="$HOME/.cargo/bin:$PATH"

# Android SDK
export ANDROID_SDK_ROOT="$HOME/Android/cmdline-tools"
export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin"
export PATH="$PATH:$ANDROID_SDK_ROOT/bin"
export PATH="$PATH:~/Development/flutter/bin"

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Deno
. "$HOME/.deno/env"

# Enable bash-style word splitting
setopt SH_WORD_SPLIT

# Tab completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Vi mode
bindkey -v
export KEYTIMEOUT=1
export PATH=/home/ninad/.nvm/versions/node/v18.17.1/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/home/ninad/.local/bin:/mnt/mint-hdd/Programming/Python/yolo-env/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/home/ninad/flutter/flutter/bin:/home/ninad/cmdline-tools/bin:/home/ninad/Android/cmdline-tools/tools/bin:/home/ninad/Android/cmdline-tools/bin:~/Development/flutter/bin:/home/ninad/.pub-cache/bin:/home/ninad/Android/android-studio/bin:/home/ninad/Android/Sdk/cmdline-tools/latest/bin:/usr/local/go/bin:/home/ninad/Android/Sdk/platform-tools/
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
eval "$(zoxide init --cmd cd zsh)"
nvm use 22 > /dev/null
