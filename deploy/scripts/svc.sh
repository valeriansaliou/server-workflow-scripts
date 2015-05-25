#!/bin/sh

config_path="$(dirname $(readlink -f "$0"))/../../instance.cfg"; . $config_path;

export GIT_SSH="${scripts_path}deploy/scripts/git_ssh.sh"

DEPLOY_SCRIPT_SH="${svc_path}$1/tools/deploy.sh"

rc_main=0
rc_sub=0

if [ -d "${svc_path}$1" ]; then
    cd "${svc_path}$1"
    git pull
    rc_main=$?

    if [ $rc_main = 0 ]; then
        if [ -f "${DEPLOY_SCRIPT_SH}" ]; then
                if [ "$2" = "bg" ]; then
                        "${DEPLOY_SCRIPT_SH}" > /dev/null 2>/dev/null &
            rc_sub=$?
                else
                        "${DEPLOY_SCRIPT_SH}"
            rc_sub=$?
                fi
        fi
    fi
else
    echo "Unknown service to be deployed - ${svc_path}$1"
    rc_main=1
fi

if [ $rc_main != 0 ]; then
        exit $rc_main
elif [ $rc_sub != 0 ]; then
        exit $rc_sub
fi
