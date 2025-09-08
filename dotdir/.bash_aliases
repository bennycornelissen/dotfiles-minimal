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
elif [[ $(uname) == "Darwin" ]] && [[ $(sw_vers -productVersion | cut -d'.' -f1) -ge 12 ]]; then
  export PATH=~/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
else
  export PATH=~/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
fi

if [[ -d "${HOME}/.local/bin" ]]; then
  export PATH=${HOME}/.local/bin:$PATH
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
if which hub &>/dev/null; then
  alias git=hub
fi

alias web_time="curl -s -w '\nLookup time:\t%{time_namelookup}\nConnect time:\t%{time_connect}\nAppCon time:\t%{time_appconnect}\nRedirect time:\t%{time_redirect}\nPreXfer time:\t%{time_pretransfer}\nStartXfer time:\t%{time_starttransfer}\n\nTotal time:\t%{time_total}\n' -o /dev/null"

## Set alias to unconditionally attach Tmux. But if we're in iTerm we should use control mode
if [[ ${TERM_PROGRAM} == "iTerm.app" ]]; then
  alias tmattach='tmux -CC new-session -ADs'
else
  alias tmattach='tmux new-session -ADs'
fi

# copy KUBECONFIG file to relevant config namespace path
install_kubeconfig() {
  if [[ $# -eq 1 ]]; then
    local config_namespace=${ENVTOOLS_CONFIG_NAMESPACE?ERROR: Cannot determine Config Namespace}
    local kubeconfig_file=${1}
  else
    local config_namespace=${1}
    local kubeconfig_file=${2}
  fi

  local config_dir="${HOME}/.env/config/${config_namespace}"

  if [[ ! -d ${config_dir} ]]; then
    echo "ERROR: Config Namespace does not exist"
    return 1
  fi

  if [[ ! -r ${kubeconfig_file} ]]; then
    echo "ERROR: Cannot read kubeconfig file in ${kubeconfig_file}"
    return 1
  fi

  local kubeconfig_filename=$(basename ${kubeconfig_file} | sed "s/\.yaml$//")

  cp ${kubeconfig_file} ${config_dir}/kubeconfig/${kubeconfig_filename}
}

# List available KUBECONFIG files
kl() {
  if [[ $# -eq 0 ]]; then
    local config_namespace=${ENVTOOLS_CONFIG_NAMESPACE?ERROR: Cannot determine Config Namespace}
  else
    local config_namespace=${1}
  fi

  local config_dir="${HOME}/.env/config/${config_namespace}"

  if [[ ! -d ${config_dir} ]]; then
    echo "ERROR: Config Namespace does not exist"
    return 1
  fi

  ls ${config_dir}/kubeconfig/

}

# Select KUBECONFIG file -- allows to use multiple clusters in different terminals at the same time
ks() {
  case $# in
    1)
      local config_namespace=${ENVTOOLS_CONFIG_NAMESPACE?ERROR: Cannot determine Config Namespace}
      local kubeconfig_id=${1}
      ;;
    2)
      local config_namespace=${1}
      local kubeconfig_id=${2}
      ;;
    *)
      echo "USAGE: $0 <config namespace> <Kubeconfig ID>"
      return 1
      ;;
  esac

  local config_dir="${HOME}/.env/config/${config_namespace}"

  if [[ ! -d ${config_dir} ]]; then
    echo "ERROR: Config Namespace does not exist"
    return 1
  fi

  local kubeconfig="${config_dir}/kubeconfig/${kubeconfig_id}"

  if [[ ! -r ${kubeconfig} ]]; then
    echo "ERROR: Kubeconfig ${kubeconfig_id} not found"
    return 1
  fi

  export KUBECONFIG=${kubeconfig}
  kubeon
}

_ks() {
  COMPREPLY=($(compgen -W "$(kl | tr ' ' '\n')" -- ${COMP_WORDS[COMP_CWORD]}))
}

complete -o nospace -F _ks ks

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

eval "$(direnv hook bash)"
export DIRENV_LOG_FORMAT=

if [[ -n ${CODESPACE_NAME} || -n ${GITPOD_ENVIRONMENT_ID} ]]; then
  for file in "${HOME}/.bashrc.d/"*; do
    source ${file}
  done
fi

# make sure loading of bash_profile exits with 0, even if no bash_profile.local exists
true
