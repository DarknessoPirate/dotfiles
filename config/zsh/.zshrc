export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
# Directory to store zinit and plugins
ZINIT_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git

# Download Zinit if it's not there
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ZSH plugins

# Install starship binary
zinit ice depth=1 as"command" from"gh-r"
zinit light starship/starship

if [ -n "$DESKTOP_SESSION" ]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
fi
eval "$(starship init zsh)"

# Initialize fzf 
eval "$(fzf --zsh)"

# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab


# snippets for other plugins
zinit snippet OMZP::git ## oh my zsh git plugin

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q
# History size (commands) 
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory 
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi
export LS_COLORS='di=1;34:ln=32:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'


# Completion styling (ignore lower/uppercase differences)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no #disable default zsh completion menu
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# Coloring guide in LS_COLORS
# di: Directory
# fi: File
# ln: Symbolic link
# pi: FIFO (named pipe)
# so: Socket
# bd: Block device
# cd: Character device
# or: Orphan (symbolic link pointing to a non-existent file)
# mi: Non-existent file pointed to by a symbolic link (visible when you type ls -l)
# ex: Executable file (has 'x' set in permissions)
# 00: Default color
# 01: Bold
# 04: Underlined
# 30: Black
# 31: Red
# 32: Green
# 33: Orange
# 34: Blue
# 35: Purple
# 36: Cyan
# 37: Grey
# 40: Black background
# 41: Red background
# 42: Green background
# 43: Orange background
# 44: Blue background
# 45: Purple background
# 46: Cyan background
# 47: Grey background
# 90: Dark grey
# 91: Light red
# 92: Light green
# 93: Yellow
# 94: Light blue
# 95: Light purple
# 96: Turquoise
# 97: White
# 100: Dark grey background
# 101: Light red background
# 102: Light green background
# 103: Yellow background
# 104: Light blue background
# 105: Light purple background
# 106: Turquoise background
# 107: White background
# 
# 


# KEYBINDS 

bindkey '^f' autosuggest-accept # accept autosuggestions
bindkey '^p' history-search-backward # search history backward
bindkey '^n' history-search-forward # search history forward
bindkey '^Y' undo
bindkey '^J' backward-word      # jump word left  
bindkey '^l' forward-word       #  jump word right
bindkey '^[i' clear-screen       # clear screen
bindkey '^E' kill-word          # delete word in front
bindkey '^W' backward-kill-word # ctrl + backspace delete word 
bindkey '^H' backward-kill-word   

# DISABLE THE ;5C ;5D ... bullshit
bindkey '^[[1;5D' backward-word         # Ctrl+Left - jump word left
bindkey '^[[1;5C' forward-word          # Ctrl+Right - jump word right
bindkey '^[[1;5A' history-search-backward   # Ctrl+Up - search history backward
bindkey '^[[1;5B' history-search-forward    # Ctrl+Down - search history forward
