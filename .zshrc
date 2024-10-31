# path to zsh installation
export ZSH="$HOME/.oh-my-zsh"

# theme name
ZSH_THEME="robbyrussell"

# case insensitive completion
CASE_SENSITIVE="false"

# hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

# auto-update
zstyle ':omz:update' mode auto

# disable auto setting
DISABLE_AUTO_TITLE="true"

# enable command auto-correction
ENABLE_CORRECTION="true"

# display dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# disable marking untracked files as dirty
DISABLE_UNTRACKED_FILES_DIRTY="true"

# load plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# prefered editor editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
  export VISUAL='code'
fi

# remove startup message
touch ~/.hushlogin

# define variables
pink_color="\033[38;2;235;189;187m"
reset_color="\033[0m"
blue_color="\033[1;34m"
red_color="\033[0;31m"
bold_pink="\033[1;38;2;235;189;187m"
directory_icon="󰉋"
home_icon=""

# fancy_ls function
fancy_ls() {
  if [ "$PWD" = "$HOME" ]; then
    directory_name="m@afterlike"
    current_icon="$home_icon"
  else
    directory_name="${PWD##*/}"
    current_icon="$directory_icon"
  fi

  echo -e "${pink_color}╭────────────────────────${reset_color}"
  echo -e "${pink_color}│ ${bold_pink}${current_icon} ${directory_name}${reset_color}"
  echo -e "${pink_color}│${reset_color}"

  command /bin/ls -1aF --color=auto 2>/dev/null | command /usr/bin/awk -v pink_color="$pink_color" -v red_color="$red_color" -v reset_color="$reset_color" -v directory_icon="$directory_icon" '
    /^\./ { printf "%s├ %s %s\033[0m\n", pink_color, red_color, $0; next } # Hidden files in red
    /\/$/ { printf "%s├ \033[1;34m%s %s\033[0m\n", pink_color, directory_icon, $0; next }
    /\.sh$/ { printf "%s├ \033[0;37m %s\033[0m\n", pink_color, $0; next }
    /\.py$/ { printf "%s├ \033[0;37m %s\033[0m\n", pink_color, $0; next }
    /\.txt$/ { printf "%s├ \033[0;37m %s\033[0m\n", pink_color, $0; next }
    /\.md$/ { printf "%s├ \033[0;37m %s\033[0m\n", pink_color, $0; next }
    /\.(jpg|jpeg|png|gif)$/ { printf "%s├ \033[0;37m %s\033[0m\n", pink_color, $0; next }
    /\.(mp4|mkv|webm)$/ { printf "%s├ \033[0;37m %s\033[0m\n", pink_color, $0; next }
    /\.(mp3|wav)$/ { printf "%s├ \033[0;37m %s\033[0m\n", pink_color, $0; next }
    { printf "%s│ \033[0;37m %s\033[0m\n", pink_color, $0 }
  '

  echo -e "${pink_color}╰────────────────────────${reset_color}"
}

# config function
config() {
  if [ -z "$1" ]; then
    builtin cd "$HOME/.config" || echo "Cannot change directory to ~/.config"
  else
    builtin cd "$HOME/.config/$1" || echo "Cannot change directory to ~/.config/$1"
  fi
}

# update outdated packages after running brew commands
function brew() {
  command brew "$@" 

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_update
  fi
}

# load add-zsh-hook
autoload -U add-zsh-hook

# run fancy_ls after changing directories
ls_after_cd() {
  fancy_ls
}

# add hook for directory changes
add-zsh-hook chpwd ls_after_cd

# tree function
tree() {
  if [ ! -d "$PWD" ]; then
    echo "Error: Current directory does not exist."
    return 1
  fi

  local current_dir="${PWD##*/}"

  # if in root
  if [[ "$PWD" == "/" ]]; then
    echo -e "${pink_color}╭────────────────────────${reset_color}"
    echo -e "${pink_color}│ ${bold_pink}${directory_icon} /${reset_color}"
    echo -e "${pink_color}╰────────────────────────${reset_color}"
    return
  fi

  echo -e "${pink_color}╭────────────────────────${reset_color}"
  echo -e "${pink_color}│ ${bold_pink}${directory_icon} ${current_dir}${reset_color}"
  echo -e "${pink_color}│${reset_color}"

  local indent=""
  local parent_path="$PWD"

  while true; do
    parent_path="${parent_path%/*}"
    local parent_dir="${parent_path##*/}"

    # handle root directory
    if [[ -z "$parent_path" ]]; then
      parent_path="/"
      parent_dir="/"
    fi

    if [[ "$parent_path" == "$PWD" ]] || [[ "$parent_path" == "/" ]]; then
      echo -e "${pink_color}├${indent}${blue_color} ${directory_icon} ${parent_dir}${reset_color}"
      break
    fi

    echo -e "${pink_color}├${indent}${blue_color} ${directory_icon} ${parent_dir}${reset_color}"
    indent="${indent}──"
  done

  echo -e "${pink_color}╰────────────────────────${reset_color}"
}

# back function
back() {
  local count=${1:-1}
  if ! [[ "$count" =~ ^[0-9]+$ ]]; then
    echo "Error: Argument must be a positive integer."
    return 1
  fi

  local path=""
  for ((i = 0; i < count; i++)); do
    path="../$path"
  done

  if ! builtin cd "$path"; then
    echo "Error: Cannot go back $count directories."
    return 1
  fi
}

# application aliases
alias spotify="open -a 'Spotify'"
alias zen="open -na 'Zen Browser'"
alias chatgpt="open -a 'ChatGPT'"
alias discord="open -a 'Discord'"

# system aliases
alias reload="source ~/.zshrc"
alias matrix="unimatrix"
alias ls="fancy_ls"

# run fastfetch on startup
if command -v fastfetch &>/dev/null; then
  fastfetch
else
  echo "Note: 'fastfetch' is not installed."
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
