#!/bin/sh

config_path="$(dirname $(readlink -f "$0"))/../../instance.cfg"; . $config_path;

PID_DIR="${scripts_path}run/pids/"

rc=0

run_cron_job()
{
    c_rc=0
    cd "$1"

    base_name=$(basename "$1")
    pid_file="$PID_DIR$base_name.pid"
    django_pid=$(cat -s "$pid_file" 2>>/dev/null)

    if [ "$django_pid" ]; then
        echo "Running Django cron jobs... - $1"
        ./tools/manage.py runcrons
        c_rc=$?
        echo "Done."
    else
        echo "Ignored Django cron jobs (not running) - $1"
    fi

    if [ $rc = 0 ]; then
        rc=$c_rc
    fi
}

if [ "$1" ]; then
    if [ -d "${web_path}$1" ]; then
        if [ -f "${web_path}$1/tools/manage.py" ]; then
            run_cron_job "${web_path}$1"
        else
            echo "Not a Django website - ${web_path}$1"
            c_rc=1
        fi
    else
        echo "Unknown cron job to be ran - ${web_path}$1"
        rc=1
    fi
else
    echo "Running cron jobs on all websites..."

    for cur_dir in $(find ${web_path} -mindepth 1 -maxdepth 1 -type d)
    do
        if [ -f "$cur_dir/tools/manage.py" ]; then
            run_cron_job "$cur_dir"
        fi
    done

    echo "Ran cron jobs on all websites."
fi

if [ $rc != 0 ]; then
    exit $rc
fi
