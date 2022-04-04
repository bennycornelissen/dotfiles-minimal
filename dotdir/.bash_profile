# Load shell-functions
if [ -r ${HOME}/.shell-functions.sh ]; then
  source ${HOME}/.shell-functions.sh
fi


# Load envtools
if [ -r ${HOME}/.shell-libs/envtools.sh ]; then
  source ${HOME}/.shell-libs/envtools.sh
fi

# Load envtools completion for bash
if [ -r ${HOME}/.shell-libs/envtools-completion-bash.sh ]; then
  source ${HOME}/.shell-libs/envtools-completion-bash.sh
fi


# Set PATH. On Linux, check for Linuxbrew
if [[ $(uname) == "Linux" ]] && [[ -d /home/linuxbrew/.linuxbrew/bin ]]; then
  export PATH=~/bin:/home/linuxbrew/.linuxbrew/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
elif [[ $(uname) == "Darwin" ]] && [[ $(sw_vers -productVersion) =~ 12.* ]]; then
  export PATH=~/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
else
  export PATH=~/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
fi

# Global exports
export CLICOLOR=1
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Global aliases
alias getip='curl icanhazip.com'
alias tf='terraform'
alias da="direnv allow"
alias k='kubectl'
alias kc='kubectx'
alias kns='kubens'

# If Github's 'hub' is installed, alias 'git' to it
if which hub &> /dev/null ; then
  alias git=hub
fi

alias web_time="curl -s -w '\nLookup time:\t%{time_namelookup}\nConnect time:\t%{time_connect}\nAppCon time:\t%{time_appconnect}\nRedirect time:\t%{time_redirect}\nPreXfer time:\t%{time_pretransfer}\nStartXfer time:\t%{time_starttransfer}\n\nTotal time:\t%{time_total}\n' -o /dev/null"

## Set alias to unconditionally attach Tmux. But if we're in iTerm we should use control mode
if [[ ${TERM_PROGRAM} == "iTerm.app" ]]; then
  alias tmattach='tmux -CC new-session -ADs'
else
  alias tmattach='tmux new-session -ADs'
fi


if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# Load FZF if present
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# enable shell completion for kubectl
if which kubectl &>/dev/null; then
  . <(kubectl completion bash)
  complete -F __start_kubectl k
fi

if which kustomize &>/dev/null; then
  . <(kustomize completion bash)
fi

[[ -r "$HOME/.bash_profile.local" ]] && source "$HOME/.bash_profile.local" # Load .profile if it exists

eval "$(direnv hook bash)"
export DIRENV_LOG_FORMAT=

# make sure loading of bash_profile exits with 0, even if no bash_profile.local exists
true

