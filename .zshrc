# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"

ZSH_THEME="crunch"

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

##### FUNCTIONS #####

function create_project()
{
    mvn archetype:generate -DgroupId=$1 -DartifactId=$2 -DarchetypeArtifactId=maven-archetype-quickstart
}

function create_mvn_archetype() {
    if [ "$#" -ne "2" ]
    then
        echo "Usage: create_mvn_archetype group_id artifact_id"
        return 1
    fi
    mvn archetype:generate \
        -DgroupId=$1 \
        -DartifactId=$2 \
        -DarchetypeArtifactId=maven-archetype-archetype
}

function create_hadoop_bootstrap() {
    mvn archetype:generate \
        -DarchetypeGroupId=com.michaelmiklavcic \
        -DarchetypeArtifactId=hadoop-bootstrap-archetype \
        -DarchetypeVersion=1.0-SNAPSHOT
}

function create_java_bootstrap() {
    mvn archetype:generate \
        -DarchetypeGroupId=com.michaelmiklavcic \
        -DarchetypeArtifactId=java-bootstrap-archetype \
        -DarchetypeVersion=1.0-SNAPSHOT
}

function regen_eclipse()
{
    mvn eclipse:eclipse -DdownloadSources -DdownloadJavadocs
}

function jpg2pdf()
{
    sips -s format pdf $1 --out $2
}

function push_to()
{
    mvn package && scp target/*.jar $1
}

#create an executable shell script
function mkshellscript() {
    if [[ -z $1 ]]; then
        echo "Need more cowbell - script name missing, boss ;-P"
        return 1
    fi
    local fileName=${1}.sh
    touch $fileName
    chmod +x $fileName
    # keep the lack of indentation below to ensure the file
    cat << 'EOF' > $fileName
#!/bin/bash

pushd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" > /dev/null

echo "Running..."
echo "Done running"

popd > /dev/null

EOF
}

function cdp() {
    match=$1
    parentDir=${PWD%${match}*}${match}
    cd $parentDir
    unset parentDir
}

function init_docker() {
    docker-machine create --driver virtualbox --virtualbox-disk-size "51200" --virtualbox-memory "8192" --virtualbox-cpu-count "4" default
}

function vssh() {
    ssh root@node1
}

##### END FUNCTIONS #####


export PROMPT_COMMAND="history -a; history -n;$PROMPT_COMMAND"
bindkey -v
bindkey "^R" history-incremental-search-backward

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git)
plugins=(git osx scala vi-mode screen battery)
#plugins=(git osx scala screen battery)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin

# MacPorts Installer addition on 2013-04-10_at_23:36:02: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

# display permissions as numeric
alias cls="ls -l | awk '{k=0;for(i=0;i<=8;i++)k+=((substr(\$1,i+2,1)~/[rwx]/) *2^(8-i));if(k)printf(\"%0o \",k);print}'"
alias cstat="stat -f '%A %N'"

# docker
export EXPOSE_DNS=true

# for mac os
help() {
    comm=$1
    if [[ -z $1 ]]; then
        echo "Need command name as arg"
        return 1
    fi
    bash -c "help $comm" | less
}

