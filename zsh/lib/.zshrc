source $HOME/.zsh/grml-zsh-config.zsh

#### My custom lines start
export PATH="$HOME/.cabal/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

bindkey \^U backward-kill-line

alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'"

alias pactlsinks="pactl --format=json list sinks | jq 'map(.index, .description)'"

alias zshrc="$EDITOR $HOME/.zsh/.zshrc && source $HOME/.zshrc"
alias alacrittyrc="$EDITOR $HOME/.config/alacritty/alacritty.toml"

alias dc="docker-compose"
function dockerbp() {
  # TODO
  # local dockerfile=$2 || "Dockerfile-prod" 
  docker build -f Dockerfile-prod -t $1 . --no-cache
}

# TODO: explore how I use $EDITOR, maybe need changes
# alias vim="nvim -u $HOME/.config/nvim_simple/init.lua"
alias vim="nvim"
alias e="nvim"

export NOTES_DIR="$HOME/Notes"
export TREEC_DIR="$HOME/.treec"

alias vimn="nvim -i $HOME/.local/state/nvim/contexts/notes.shada -c \"MyNotesConfig\" -c \"cd $NOTES_DIR\""
alias notes="vimn"
alias en="vimn"

alias vimnt="nvim -i $HOME/.local/state/nvim/contexts/notestreec.shada -c \"MyNotesConfig\" -c \"cd $TREEC_DIR\""
alias treec="vimnt"
alias ent="vimnt"

alias vimp="nvim -i $HOME/.local/state/nvim/contexts/personal.shada"
alias ep="vimp"

# incognito
alias vimi="nvim -i NONE"

alias ls="/usr/bin/lsd"

### XMonad
alias xmobarrc="$EDITOR $HOME/.config/xmobar"
# alias xmobarrc="nvim -c \"cd $HOME/.config/xmobar/ | e ./xmobarrc.hs | set syntax=haskell\""
# TODO: xmobarrc (with or without .hs) could be defined in lsp hook or whatever I have for Dockerfile-prod

# required since I want to use specific config file
# TODO: I think some lines can be improved
# FIXME: not relevant since using pacman xmonad/xmobar?
function recompile_xmonad() {
  cd $HOME/.config/xmonad
  CONFIG_FILE=$(find $HOME/.config/xmonad/$1.hs -printf %f || echo 'xmonad.hs')
  CONFIG_TYPE=$(echo ${CONFIG_FILE:0:-3})
  mkdir -v $HOME/.scripts 2> /dev/null
  mkdir -v $HOME/.scripts/xmonad 2> /dev/null
  ghc -dynamic --make $CONFIG_FILE -i$HOME/.config/xmonad/ -ilib -fforce-recomp -main-is main -v0 -outputdir $HOME/.scripts/$CONFIG_TYPE/build-x86_64-linux -o $HOME/.scripts/$CONFIG_TYPE/xmonad-x86_64-linux
  echo "$CONFIG_TYPE recompiled"
  # TODO: why does it get displayed twice?
  $HOME/.scripts/$CONFIG_TYPE/xmonad-x86_64-linux --version
}

# FIXME: not relevant since using pacman xmonad/xmobar?
# alias xmonadrcplasma="nvim -c \"cd $HOME/.config/xmonad | e xmonad-plasma.hs\" && recompile_xmonad xmonad-plasma"
alias xmonadrc="cd $HOME/.config/xmonad && nvim -c \"e xmonad.hs\" && xmonad --recompile"
###

alias weztermrc="nvim $HOME/.config/wezterm/wezterm.lua"
alias wezrc="weztermrc"

alias trivyv="trivy image --format json --scanners vuln --severity \"HIGH,CRITICAL,MEDIUM\""
alias trivytest="trivy image --format json --scanners vuln --severity \"HIGH,CRITICAL,MEDIUM\""

# find cmd shortening
alias f="find"
# FIXME: still actual?
# clear neovim swap
alias nvimswap="rm $HOME/.local/state/nvim/swap/*"
#
# case insensitive
export LESS=-Ri
alias grep="grep --color"

# human readable and only disk drives
alias df="df -h --type ext4 --type vfat --type ntfs" 

alias nvimrc="cd ~/.config/nvim && nvim"

### GIT
# get git last commit msg
alias gitlcm="git log -1 --pretty=%B | cat"

# TODO: git aliases
alias gmaster="git checkout master && git pull"
alias gmain="git checkout main && git pull"
###

function httpcode() {
  cat ~/.zsh/httpcodes.json | jq ".[\"$1\"]"
}

# current work environment related configs
[ -f "$HOME/projects/scripts/work.inc.zsh" ] && source "$HOME/projects/scripts/work.inc.zsh" 

# TODO: using xmonad/xmobar from pacman now so I think not needed? 
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/projects/scripts/gcloud/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/projects/scripts/gcloud/google-cloud-sdk/path.zsh.inc" ; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/projects/scripts/gcloud/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/projects/scripts/gcloud/google-cloud-sdk/completion.zsh.inc" ; fi

hash -d scr="$HOME/.scripts"
hash -d cfg="$HOME/.scripts/git/configs"

source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# source ~/.zsh_custom/git.plugin.zsh

