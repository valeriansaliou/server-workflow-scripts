#!/bin/bash

config_path="$(dirname $(readlink -f "$0"))/../instance.cfg"; . $config_path;

# Devices to check
EMAIL_SUBJECT="[CRITICAL] Server disk full"
EMAIL_HEAD="Dear Master,"
EMAIL_CONTENT="The following disk is almost full:"
EMAIL_FOOT="Your Slave, from ${server_city} (${server_country})."
EMAIL_META="VM: ${server_name} - DNS: ${server_domain} - DC: ${server_provider} (${server_country})"

for devname in $disks_check
do
  let p=`df -k $devname | grep -v ^File | awk '{printf ("%i",$3*100 / $2); }'`
  if [[ $p -ge "$disks_threshold" ]]; then
    echo -e "${EMAIL_HEAD}\n\n${EMAIL_CONTENT} ${devname}\n\n$(df -h $devname)\n\n\n${EMAIL_FOOT}\n\n\n${EMAIL_META}" | /usr/bin/mail -s "${EMAIL_SUBJECT}" "${admin_email}"
  fi
done
