#!/bin/zsh
# Auto configure zsh proxy env based on system preferences
# Sukka (https://skk.moe)

# Cache the output of scutil --proxy
__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY=$(scutil --proxy)
__ZSH_OSX_AUTOPROXY_HTTP_PROXY_ENABLE=0

if [[ $__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY == *"HTTPEnable : 1"* ]]; then
  __ZSH_OSX_AUTOPROXY_HTTP_PROXY_ENABLE=1
fi

# http proxy
if (( $__ZSH_OSX_AUTOPROXY_HTTP_PROXY_ENABLE )); then
    __ZSH_OSX_AUTOPROXY_HTTP_PROXY_SERVER=${${__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY#*HTTPProxy : }[(f)1]}
    __ZSH_OSX_AUTOPROXY_HTTP_PROXY_PORT=${${__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY#*HTTPPort : }[(f)1]}
    export http_proxy="http://${__ZSH_OSX_AUTOPROXY_HTTP_PROXY_SERVER}:${__ZSH_OSX_AUTOPROXY_HTTP_PROXY_PORT}"
    export HTTP_PROXY="${http_proxy}"
fi
# https_proxy
if [[ $__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY == *"HTTPSEnable : 1"* ]]; then
    __ZSH_OSX_AUTOPROXY_HTTPS_PROXY_SERVER=${${__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY#*HTTPSProxy : }[(f)1]}
    __ZSH_OSX_AUTOPROXY_HTTPS_PROXY_PORT=${${__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY#*HTTPSPort : }[(f)1]}
    export https_proxy="http://${__ZSH_OSX_AUTOPROXY_HTTPS_PROXY_SERVER}:${__ZSH_OSX_AUTOPROXY_HTTPS_PROXY_PORT}"
    export HTTPS_PROXY="${https_proxy}"
fi
# ftp_proxy
if [[ $__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY == *"FTPSEnable : 1"* ]]; then
    __ZSH_OSX_AUTOPROXY_FTP_PROXY_SERVER=${${__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY#*FTPProxy : }[(f)1]}
    __ZSH_OSX_AUTOPROXY_FTP_PROXY_PORT=${${__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY#*FTPPort : }[(f)1]}
    export ftp_proxy="http://${__ZSH_OSX_AUTOPROXY_FTP_PROXY_SERVER}:${__ZSH_OSX_AUTOPROXY_FTP_PROXY_PORT}"
    export FTP_PROXY="${ftp_proxy}"
fi
# all_proxy
if [[ $__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY == *"SOCKSEnable : 1"* ]]; then
    __ZSH_OSX_AUTOPROXY_SOCKS_PROXY_SERVER=${${__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY#*SOCKSProxy : }[(f)1]}
    __ZSH_OSX_AUTOPROXY_SOCKS_PROXY_PORT=${${__ZSH_OSX_AUTOPROXY_SCUTIL_PROXY#*SOCKSPort : }[(f)1]}
    export all_proxy="http://${__ZSH_OSX_AUTOPROXY_SOCKS_PROXY_SERVER}:${__ZSH_OSX_AUTOPROXY_SOCKS_PROXY_PORT}"
    export ALL_PROXY="${all_proxy}"
elif (( $__ZSH_OSX_AUTOPROXY_HTTP_PROXY_ENABLE )); then
    export all_proxy="${http_proxy}"
    export ALL_PROXY="${all_proxy}"
fi
