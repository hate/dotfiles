export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="mh"

zstyle ':omz:update' mode auto 
zstyle ':omz:update' frequency 14

plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

alias docker-compose="docker compose"

alias g++="g++ -std=c++11"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/emulator
export NDK_HOME=/Users/lelo/Library/Android/sdk/ndk/28.0.13004108

# pnpm
export PNPM_HOME="/Users/lelo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# bun completions
[ -s "/Users/lelo/.bun/_bun" ] && source "/Users/lelo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
