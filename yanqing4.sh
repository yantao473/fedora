#!/bin/sh

export PATH=$PATH:/home/yanqing4/bin

git_branch()
{
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ "x${branch}x" != "xx" ]
    then
        echo -e " \033[33;1m($branch)\033[0m"
    else
        echo ""
    fi
}

if [ -n "$BASH_VERSION" ]
then
    export PS1="[\$(git_branch) \[\e[1;32m\]\W \t\[\e[m\]] \\$ "
elif [ -n "$ZSH_VERSION" ]
then
    set_prompt() {
        # set terminal tab title
        # window_title="\033]0;${PWD##*/}\007"
        # echo -ne "$window_title"

        if [ "$UID" -eq 0 ]
        then
            PROMPT="[%F{135}%n%f %F{166}%*%f$(git_branch)] %F{118}%1~%f %# "
        else
            PROMPT="[%F{135}%n%f %F{166}%*%f$(git_branch)] %F{118}%1~%f $ "
        fi
    }

    precmd_functions+=(set_prompt)
    # chpwd_functions+=(set_prompt)
    set_prompt

    export RPROMPT="%F{red}%(?..%?)%f"
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_IGNORE_SPACE
    # [ -f ~/sw/z.sh ] && source ~/sw/z.sh
    # [ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
    HISTFILE=~/.zhistory
    HISTSIZE=5000
    SAVEHIST=5000
fi

alias g='grep --color=auto'
alias p='ps axjfww'
alias use_proxy="systemctl start privoxy.service && export http_proxy=http://127.0.0.1:8118 && export https_proxy=http://127.0.0.1:8118"
alias unuse_proxy="unset http_proxy && unset https_proxy && systemctl stop privoxy.service"


ESC="\033[1;"
GRE="${ESC}32m"
YEL="${ESC}33m"
RED="${ESC}31m"
NOR="${ESC}0m"

vput() {
    for i in "$@"
    do
        CURTIME=$(date  +'%Y-%m-%d %H:%M:%S')
        rsync --progress "$i" 10.73.26.132::vdisk/ \
            && printf "${GRE}OK $i\t$CURTIME\n$NOR" \
            || printf "${RED}Failed $i\t$CURTIME\n$NOR"
    done
}

vget() {
    ARGS=$#
    CURTIME=$(date  +'%Y-%m-%d %H:%M:%S')

    if [ $ARGS -eq 1 ]
    then
        rsync --progress 10.73.26.132::vdisk/"$1" . \
            && printf "${GRE}OK $1\t$CURTIME\n$NOR" \
            || printf "${RED}Failed $1\t$CURTIME\n$NOR"
    elif [ $ARGS -eq 2 ]
    then
        rsync --progress 10.73.26.132::vdisk/"$1" $2 \
            && printf "${GRE}OK $1\t$CURTIME\n$NOR" \
            || printf "${RED}Failed $1\t$CURTIME\n$NOR"
    else
        dest=${!ARGS}
        dp=$(dirname $dest)

        if [[ -w $dest && -d $dp  ]]
        then
            for ((i=1; i < $ARGS; i++))
            do
                CURTIME=$(date  +'%Y-%m-%d %H:%M:%S')
                rsync --progress 10.73.26.132::vdisk/"${!i}" $dest \
                    && printf "${GRE}OK ${!i}\t$CURTIME\n$NOR" \
                    || printf "${RED}Failed ${!i}\t$CURTIME\n$NOR"
            done
        else
            echo "The target not a folder"
        fi
    fi
}


# for fzf need install ripgrep
export FZF_DEFAULT_COMMAND='rg --files --smart-case --no-ignore --hidden --follow --glob "!{.git,.svn,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq"
export HISTIGNORE="y:pwd:ls:cd:ll:clear:history"

# for java
# export JAVA_HOME=/usr/java/jdk1.8.0_121
# export PATH=$JAVA_HOME/bin:$PATH
# export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
