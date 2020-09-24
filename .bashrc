#! /usr/bin/env bash

# functions
function ccd() {
    local default_repo="$HOME/github/dev/"
    local rootdir=$(git rev-parse --show-toplevel 2> /dev/null || echo "$default_repo")
    cd "$rootdir" || echo "ccd command from ~/.bashrc failed"
}

if [ -d "$HOME"/msft/dev/appcenter/dockercompose ]; then
  for filename in "$HOME"/msft/dev/appcenter/dockercompose/*.ps1
  do
    cmd=$(basename "$filename" .ps1)

    eval "a${cmd}() { $HOME/msft/dev/appcenter/dockercompose/${cmd}.ps1 diagnostics/docker \$@; }"
    eval "c${cmd}() { $HOME/msft/dev/appcenter/dockercompose/${cmd}.ps1 crashes-docker \$@; }"
    eval "cs${cmd}() { $HOME/msft/dev/appcenter/dockercompose/${cmd}.ps1 core-services/docker \$@; }"
    eval "d${cmd}() { $HOME/msft/dev/appcenter/dockercompose/${cmd}.ps1 distribution/docker \$@; }"
  done
fi

kcontext() {
  kubectl config view --minify
}

ghgo() {
  ~/go/src/github.com/github
}

gdv() {
  ~/github/dev
}

switchgo() {
  version=$1
  if [ -z "$version" ]; then
    echo "Usage: switchgo [version]"
    return
  fi
  if ! command -v "go$version" > /dev/null 2>&1; then
    echo "version does not exist, downloading with commands: "
    echo "  go get golang.org/dl/go${version}"
    echo "  go${version} download"
    echo ""
    go get "golang.org/dl/go${version}"
    go"${version}" download
  fi
  go_bin_path=$(command -v "go$version")
  ln -sf "$go_bin_path" "$GOBIN/go"
  echo "Switched to ${go_bin_path}"
}

# show and switch to branches interactively
function b() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m --layout=reverse) &&
  git checkout "$(echo "$branch" | awk '{print $1}' | sed "s/.* //")"
}

# clean docker containers
function docker-containers-clean() {
  docker rm -vf "$(docker ps -a -q)"
}

# clean docker images
function docker-images-clean() {
  docker rmi -f "$(docker images -a -q)"
}

# clean both containers and images
function docker-force-clean() {
  docker-containers-clean
  docker-images-clean
}





# better bash history stuff
shopt -s histappend
HISTFILESIZE=1000000
HISTSIZE=1000000
HISTCONTROL=ignoreboth
HISTIGNORE='ls:bg:fg:history'
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -a'

##################################################
# START: only add absolute "cd" paths to history #
##################################################

# skip adding "cd" commands to history
function zshaddhistory() {
    if [[ $1 = cd\ * ]]; then
        return 1
    fi
}

# add a "cd <absolute path>" to history whenever the working directory changes
function chpwd() {
    escaped_dir=$(printf %q "$(pwd)") # escape spaces in directory names
    print -rs "cd $escaped_dir"
}

##################################################
# END: only add absolute "cd" paths to history   #
##################################################

SLACK_DEVELOPER_MENU=true