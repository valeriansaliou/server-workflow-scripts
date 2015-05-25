#!/bin/bash

config_path="$(dirname $(readlink -f "$0"))/../instance.cfg"; . $config_path;

##############################################################################
# backup_mysql.sh
#
# by Nathan Rosenquist <nathan@rsnapshot.org>
# http://www.rsnapshot.org/
#
# This is a simple shell script to backup a MySQL database with rsnapshot.
#
# The assumption is that this will be invoked from rsnapshot. Also, since it
# will run unattended, the user that runs rsnapshot (probably root) should have
# a .my.cnf file in their home directory that contains the password for the
# MySQL root user. For example:
#
# /root/.my.cnf (chmod 0600)
#   [client]
#   user = root
#   password = thepassword
#   host = localhost
#
# This script simply needs to dump a file into the current working directory.
# rsnapshot handles everything else.
##############################################################################

# $Id: backup_mysql.sh,v 1.6 2007/03/22 02:50:21 drhyde Exp $

now=$(date +"%m-%d-%Y")
mkdir -p "${backup_path}mysql"
cd "${backup_path}mysql"

umask 0077

# Backup the database
/usr/bin/mysqldump --password="$mysql_password" --all-databases --events > "$now.sql"

# Compress the backup
/bin/tar -zcvf "$now.tar.gz" "$now.sql"

# Remove the backup plain text file
rm "$now.sql"

# Make the backup readable only by root
/bin/chmod 600 "$now.tar.gz"

# Cleanup (remove files older than 1 month)
find ./ -type f -mtime +31 -exec rm {} \;
