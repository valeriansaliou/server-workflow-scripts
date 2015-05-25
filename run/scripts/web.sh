#!/bin/sh

config_path="$(dirname $(readlink -f "$0"))/../../instance.cfg"; . $config_path;

rc=0

run_website_start()
{
    c_rc=0
    cd "$1"

	if [ -f "$1/tools/run.sh" ]; then
		echo "Starting website... - $1"
		./tools/run.sh
		c_rc=$?
		echo "Started."
	else
		echo "Not a website - $1"
		c_rc=1
	fi

    if [ $rc = 0 ]; then
        rc=$c_rc
    fi
}

run_website_stop()
{
    c_rc=0
    cd "$1"

	echo "Stopping website... - $1"
	./tools/run.sh kill
	c_rc=$?
	echo "Stopped."

    if [ $rc = 0 ]; then
        rc=$c_rc
    fi
}

if [ "$1" ] && [ "$2" ]; then
    if [ -d "${web_path}$1" ]; then
    	if [ "$2" = "start" ]; then
			run_website_start "${web_path}$1"
		elif [ "$2" = "stop" ]; then
			run_website_stop "${web_path}$1"
		else
			echo "Usage {start|stop}"
		fi
    else
        echo "Unknown cron job to be ran - ${web_path}$1"
        rc=1
    fi
else
    echo "Running web task on all websites..."

    for cur_dir in $(find ${web_path} -mindepth 1 -maxdepth 1 -type d)
    do
        if [ -f "$cur_dir/tools/run.sh" ]; then
            if [ "$1" = "start" ]; then
				run_website_start "$cur_dir"
			elif [ "$1" = "stop" ]; then
				run_website_stop "$cur_dir"
			else
				echo "Usage {start|stop}"
			fi
        fi
    done

    echo "Ran web task on all websites."
fi

if [ $rc != 0 ]; then
    exit $rc
fi
