#!/bin/bash

config_path="$(dirname $(readlink -f "$0"))/../instance.cfg"; . $config_path;

now=$(date +"%m-%d-%Y")
mkdir -p "${backup_path}mongodb"
cd "${backup_path}mongodb"

umask 0077

# Backup the database
/usr/bin/mongodump --host localhost --port 27017 --username admin --password "$mongodb_password" --out "$now" >> /dev/null

# Compress the backup
/bin/tar -zcvf "$now.tar.gz" "$now"

# Remove the backup plain text file
rm -r "$now"

# Make the backup readable only by root
/bin/chmod 600 "$now.tar.gz"

# Cleanup (remove files older than 1 month)
find ./ -type f -mtime +31 -exec rm {} \;
