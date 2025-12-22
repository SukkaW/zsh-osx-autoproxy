#!/bin/zsh
# Auto configure zsh proxy env based on macOS system preferences
# Sukka (https://skk.moe)
# Homepage: https://github.com/SukkaW/zsh-osx-autoproxy
# License: MIT

zsh-osx-autoproxy() {
    emulate -L zsh -o extended_glob
    # export https_proxy=http://127.0.0.1:6152
    # export http_proxy=http://127.0.0.1:6152
    # export all_proxy=socks5://127.0.0.1:6153

    # Cache the output of scutil --proxy
    local scutil_output=$(scutil --proxy)
    local -A info=(${=${(M)${(f)scutil_output}:#[A-Za-z ]# : [^ ]#}/:})

    local proxy_enabled=0

    if (( $info[HTTPEnable] )); then
        export http_proxy=http://$info[HTTPProxy]:$info[HTTPPort]
        export HTTP_PROXY=http://$info[HTTPProxy]:$info[HTTPPort]
        proxy_enabled=1
    fi
    if (( $info[HTTPSEnable] )); then
        export https_proxy=http://$info[HTTPSProxy]:$info[HTTPSPort]
        export HTTPS_PROXY=http://$info[HTTPSProxy]:$info[HTTPSPort]
        proxy_enabled=1
    fi
    if (( $info[FTPSEnable] )); then
        export ftp_proxy=http://$info[SOCKSProxy]:$info[SOCKSPort]
        export FTP_PROXY=http://$info[SOCKSProxy]:$info[SOCKSPort]
        proxy_enabled=1
    fi
    if (( $info[SOCKSEnable] )); then
        export all_proxy=socks5://$info[SOCKSProxy]:$info[SOCKSPort]
        export ALL_PROXY=socks5://$info[SOCKSProxy]:$info[SOCKSPort]
        proxy_enabled=1
    elif (( $info[HTTPEnable] )); then
        export all_proxy=http://$info[HTTPProxy]:$info[HTTPPort]
        export ALL_PROXY=http://$info[HTTPProxy]:$info[HTTPPort]
        proxy_enabled=1
    fi

    if (( $proxy_enabled )); then
        local -A raw_scutil_noproxy=(${=${(M)${(f)scutil_output}:#  [0-9 ]# : [^ ]#}/:})
        local _noproxy=${(j:, :)${(o)raw_scutil_noproxy}}

        export NO_PROXY=$_noproxy
        export no_proxy=$_noproxy
    fi
}

if (( $OSTYPE[(I)darwin] )); then
    zsh-osx-autoproxy
fi

proxy_off() {
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset all_proxy
    unset ALL_PROXY
    unset ftp_proxy
    unset FTP_PROXY
}
