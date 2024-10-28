# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="robbyrussell"

# Enable case-insensitive completion.
CASE_SENSITIVE="false"

# Use hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

# Auto-update Oh My Zsh without prompting.
zstyle ':omz:update' mode auto

# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Load the plugins.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Source Oh My Zsh.
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions.
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'    # Terminal-based editor.
  export VISUAL='code'   # GUI editor.
fi

# Remove startup message.
touch ~/.hushlogin

# Define color and icon variables.
pink_color="\033[38;2;235;189;187m"
reset_color="\033[0m"
blue_color="\033[1;34m"
red_color="\033[0;31m"
bold_pink="\033[1;38;2;235;189;187m"
directory_icon="󰉋"
home_icon=""

# Custom function: fancy_ls
# Displays directory contents with custom icons and colors.
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

  # Use 'command' to bypass aliases and ensure original commands are used.
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

# Custom function: config
# Changes directory to ~/.config or its subdirectories.
config() {
  if [ -z "$1" ]; then
    builtin cd "$HOME/.config" || echo "Cannot change directory to ~/.config"
  else
    builtin cd "$HOME/.config/$1" || echo "Cannot change directory to ~/.config/$1"
  fi
}

# Update outdated packages after running brew commands
function brew() {
  command brew "$@" 

  if [[ $* =~ "upgrade" ]] || [[ $* =~ "update" ]] || [[ $* =~ "outdated" ]]; then
    sketchybar --trigger brew_update
  fi
}

# Ensure add-zsh-hook is loaded before using it.
autoload -U add-zsh-hook

# Hook function to run fancy_ls after changing directories.
ls_after_cd() {
  fancy_ls
}

# Add the hook for directory changes.
add-zsh-hook chpwd ls_after_cd

# Custom function: tree
# Displays the directory tree from the current directory up to root.
tree() {
  # Handle edge cases and errors gracefully.
  if [ ! -d "$PWD" ]; then
    echo "Error: Current directory does not exist."
    return 1
  fi

  local current_dir="${PWD##*/}"

  # If in root directory.
  if [[ "$PWD" == "/" ]]; then
    echo -e "${pink_color}╭────────────────────────${reset_color}"
    echo -e "${pink_color}│ ${bold_pink}${directory_icon} /${reset_color}"
    echo -e "${pink_color}╰────────────────────────${reset_color}"
    return
  fi

  echo -e "${pink_color}╭────────────────────────${reset_color}"
  echo -e "${pink_color}│ ${bold_pink}${directory_icon} ${current_dir}${reset_color}"
  echo -e "${pink_color}│${reset_color}"

  # Build the tree from the parent directories.
  local indent=""
  local parent_path="$PWD"

  while true; do
    parent_path="${parent_path%/*}"
    local parent_dir="${parent_path##*/}"

    # Handle root directory.
    if [[ -z "$parent_path" ]]; then
      parent_path="/"
      parent_dir="/"
    fi

    # Break if parent_path is the same as current or root directory.
    if [[ "$parent_path" == "$PWD" ]] || [[ "$parent_path" == "/" ]]; then
      echo -e "${pink_color}├${indent}${blue_color} ${directory_icon} ${parent_dir}${reset_color}"
      break
    fi

    echo -e "${pink_color}├${indent}${blue_color} ${directory_icon} ${parent_dir}${reset_color}"
    indent="${indent}──"
  done

  echo -e "${pink_color}╰────────────────────────${reset_color}"
}

# Simplified 'back' function.
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

# Application aliases.
alias spotify="open -a 'Spotify'"
alias zen="open -na 'Zen Browser'"  # Opens a new instance.
alias chatgpt="open -a 'ChatGPT'"
alias discord="open -a 'Discord'"

# System aliases.
alias reload="source ~/.zshrc"
alias matrix="unimatrix"
alias ls="fancy_ls"

# Remove 'history' and 'rawls' aliases as per your request.

# On startup: run 'fastfetch' if installed.
if command -v fastfetch &>/dev/null; then
  fastfetch
else
  echo "Note: 'fastfetch' is not installed."
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
