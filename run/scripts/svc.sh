#!/bin/sh

config_path="$(dirname $(readlink -f "$0"))/../../instance.cfg"; . $config_path;

rc=0

run_service_start()
{
    c_rc=0
    cd "$1"

	if [ -f "$1/tools/run.sh" ]; then
		echo "Starting service... - $1"
		./tools/run.sh
		c_rc=$?
		echo "Started."
	else
		echo "Not a service - $1"
		c_rc=1
	fi

    if [ $rc = 0 ]; then
        rc=$c_rc
    fi
}

run_service_stop()
{
    c_rc=0
    cd "$1"

	echo "Stopping service... - $1"
	./tools/run.sh kill
	c_rc=$?
	echo "Stopped."

    if [ $rc = 0 ]; then
        rc=$c_rc
    fi
}

if [ "$1" ] && [ "$2" ]; then
    if [ -d "${svc_path}$1" ]; then
    	if [ "$2" = "start" ]; then
			run_service_start "${svc_path}$1"
		elif [ "$2" = "stop" ]; then
			run_service_stop "${svc_path}$1"
		else
			echo "Usage {start|stop}"
		fi
    else
        echo "Unknown cron job to be ran - ${svc_path}$1"
        rc=1
    fi
else
    echo "Running svc task on all services..."

    for cur_dir in $(find ${svc_path} -mindepth 1 -maxdepth 1 -type d)
    do
        if [ -f "$cur_dir/tools/run.sh" ]; then
            if [ "$1" = "start" ]; then
				run_service_start "$cur_dir"
			elif [ "$1" = "stop" ]; then
				run_service_stop "$cur_dir"
			else
				echo "Usage {start|stop}"
			fi
        fi
    done

    echo "Ran svc task on all services."
fi

if [ $rc != 0 ]; then
    exit $rc
fi
