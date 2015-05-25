#!/bin/sh

config_path="$(dirname $(readlink -f "$0"))/../../instance.cfg"; . $config_path;

export GIT_SSH="${scripts_path}deploy/scripts/git_ssh.sh"

DEPLOY_SCRIPT_PHP="${web_path}$1/cli/tools/deploy.php"
DEPLOY_SCRIPT_PY="${web_path}$1/tools/deploy.py"
DEPLOY_SCRIPT_SH="${web_path}$1/tools/deploy.sh"

rc_main=0
rc_sub=0

if [ -d "${web_path}$1" ]; then
    cd "${web_path}$1"
    git pull
    rc_main=$?

    if [ $rc_main = 0 ]; then
        if [ -f "${DEPLOY_SCRIPT_PHP}" ]; then
            if [ "$2" = "bg" ]; then
                php "${DEPLOY_SCRIPT_PHP}" > /dev/null 2>/dev/null &
                rc_sub=$?
            else
                php "${DEPLOY_SCRIPT_PHP}"
                rc_sub=$?
            fi
        fi

        if [ -f "${DEPLOY_SCRIPT_PY}" ]; then
            if [ "$2" = "bg" ]; then
                python -u "${DEPLOY_SCRIPT_PY}" > /dev/null 2>/dev/null &
                rc_sub=$?
            else
                python -u "${DEPLOY_SCRIPT_PY}"
                rc_sub=$?
            fi
        fi

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
    echo "Unknown website to be deployed - ${web_path}$1"
    rc_main=1
fi

if [ $rc_main != 0 ]; then
        exit $rc_main
elif [ $rc_sub != 0 ]; then
        exit $rc_sub
fi
