######################
### zsh plugin #######
######################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/completion", from:prezto
zplug "modules/prompt", from:prezto
zplug "plugins/git", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "b4b4r07/enhancd", use:init.sh
zplug load --verbose
# prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
# fzf
function _func_dfimage() {
    IMAGE="$1"
    BASE_IMAGE=`docker inspect -f "{{len .RepoDigests }}" $IMAGE`
    if [ $BASE_IMAGE -eq 0 ]; then
        BASE_IMAGE=`docker inspect -f "{{ .Config.Image }}" $IMAGE`
    else
        BASE_IMAGE=`docker inspect -f "{{index .RepoDigests 0}}" $IMAGE`
    fi

    USER="root"
    if [ -n "$2" ]; then
        USER="$2"
    fi

    # Print base image
    echo "FROM $BASE_IMAGE"

    # Get bash history commands
    docker run -it -u $USER $IMAGE cat /$USER/.bash_history | sed 's/\r$//g' > .tmp.txt
    HEAD_CMD=$(head -n 1 .tmp.txt)
    sed -i '1d' .tmp.txt
    TAIL_CMD=$(tail -n 1 .tmp.txt)
    sed -i '$d' .tmp.txt

    # make commands
    echo "RUN $HEAD_CMD && \\"
    cat .tmp.txt | while read cmd; do
        cmd=`echo $cmd | sed -e 's/apt\-get/apt/g' -e 's/apt/apt\ \-y/g'`
        if [ "$cmd" = "ls" ]; then
            continue
        fi
        echo "    $cmd && \\"
    done
    echo "    $TAIL_CMD"

    # Delete tempolary file
    rm -rf .tmp.txt
}
alias dfimage=_func_dfimage
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "source "$HOME/.fzf.zshrc""
### powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
### jump
eval "$(jump shell)"
### zprof
if (which zprof > /dev/null 2>&1) ;then
    zprof | less
fi
######################
### anyenv ###########
######################
if [ -e "$HOME/.anyenv" ]
then
    export ANYENV_ROOT="$HOME/.anyenv"
    export PATH="$ANYENV_ROOT/bin:$PATH"
    if command -v anyenv 1>/dev/null 2>&1
    then
        eval "$(anyenv init -)"
    fi
fi
### pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
### rbenv
[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"
### tfenv
export PATH=${HOME}/.tfenv/bin:${PATH}
### goenv
export GOPATH=$HOME/go
export GOENV_ROOT=$HOME/.goenv
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
eval "$(anyenv init - --no-rehash)"
######################
### 環境変数 ##########
######################
### k8s
export PATH="/usr/local/bin/eksctl:${PATH}"
# complete -F __start_kubectl k
[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
### mysql
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
### editor
EDITOR='vim'
######################
### alias ############
######################
### terraform
alias tf='terraform'
### k8s
alias k=kubectl
alias d=docker
alias kb=kubebuilder
### git
alias g='git'
alias ga='git add .'
alias gb='git branch'
alias gcb='git checkout -b'
alias gc='git commit'
alias gcm='git commit -m'
alias gl='git plog'
alias gm='git merge'
alias gmm='git merge master'
alias gpso='git push origin'
alias gplo='git pull origin'
alias gs='git status'
alias ma='master'
alias ch='checkout'
######################
### shell script #####
######################
lssh () {
  IP=$(lsec2 $@ | peco | awk '{print $2}')
  if [ $? -eq 0 -a "${IP}" != "" ]
  then
      echo ">>> SSH to ${IP}"
      ssh ${IP}
  fi
}
######################
### tmux #############
######################
# if [[ ! -n $TMUX && $- == *l* ]]; then
#   # get the IDs
#   ID="`tmux list-sessions`"
#   if [[ -z "$ID" ]]; then
#     tmux new-session
#   fi
#   create_new_session="Create New Session"
#   ID="$ID\n${create_new_session}:"
#   ID="`echo $ID | peco | cut -d: -f1`"
#   if [[ "$ID" = "${create_new_session}" ]]; then
#     tmux new-session
#   elif [[ -n "$ID" ]]; then
#     tmux attach-session -t "$ID"
#   else
#     :  # Start terminal normally
#   fi
# fi

clear