#!/bin/sh

export PATH=$PATH:/home/yanqing4/bin
export PS1="[\$(git_branch) \[\e[1;32m\]\w \t\[\e[m\] ] \\$ "

alias g='grep --color=auto'
alias p='ps axjfww'
alias use_proxy="systemctl start privoxy.service && export http_proxy=http://127.0.0.1:8118 && export https_proxy=http://127.0.0.1:8118"
alias unuse_proxy="unset http_proxy && unset https_proxy && systemctl stop privoxy.service"


ESC="\033[1;"
GRE="${ESC}32m"
YEL="${ESC}33m"
RED="${ESC}31m"
NOR="${ESC}0m"


# fasd
eval "$(fasd --init auto)"
alias v='f -e vim'
fasd_cd ()
{
 if [ $# -le 1 ]; then
     fasd "$@";
 else
     local _fasd_ret="$(fasd -e 'printf %s' "$@")";
     [ -z "$_fasd_ret" ] && return;
     [ -d "$_fasd_ret" ] && printf %s\\n "$_fasd_ret" && cd "$_fasd_ret";
 fi
}


mkcd()
{
    mkdir $1
    cd $1
}

git_branch()
{
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ "$branch" = "" ]
    then
        echo ""
    else
        echo -e " \033[33;1m($branch)\033[0m"
    fi
}

saeput() {                                                                                              
    for i in "$@"                                                                                        
    do
        CURTIME=$(date  +'%Y-%m-%d %H:%M:%S')                                                            
        rsync --progress "$i" sae.rsync.sae.sina.com.cn::sae/ \
            && printf "${GRE}OK $i\t$CURTIME\n$NOR" \
            || printf "${RED}Failed $i\t$CURTIME\n$NOR"                                                  
    done    
}   

saeget() {                                                                                              
    ARGS=$#                                                                                              
    CURTIME=$(date  +'%Y-%m-%d %H:%M:%S')                                                                

    if [ $ARGS -eq 1 ]                                                                                   
    then 
        rsync --progress sae.rsync.sae.sina.com.cn::sae/"$1" . \
            && printf "${GRE}OK $1\t$CURTIME\n$NOR" \
            || printf "${RED}Failed $1\t$CURTIME\n$NOR"
    elif [ $ARGS -eq 2 ]
    then
        rsync --progress sae.rsync.sae.sina.com.cn::sae/"$1" $2 \
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
                rsync --progress sae.rsync.sae.sina.com.cn::sae/"${!i}" $dest \
                    && printf "${GRE}OK ${!i}\t$CURTIME\n$NOR" \
                    || printf "${RED}Failed ${!i}\t$CURTIME\n$NOR"
            done
        else
            echo "The target not a folder"
        fi
    fi
}

export FZF_DEFAULT_COMMAND='ag -g ""'
export HISTIGNORE="myss:bearychat:y:pwd:ls:cd:ll:clear:history"
