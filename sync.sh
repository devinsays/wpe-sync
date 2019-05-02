#!/bin/bash -e

# Default false for flags
db=false
uploads=false
plugins=false
overwrite=false

# Checks for flags
while getopts dupo option
do
	case "${option}"
	in
	d) db=true;;
	u) uploads=true;;
	p) plugins=true;;
	o) overwrite=true;;
esac
done

# Sets variable for message display
env_message=false

function wpe_get_database() {
	env_message=true
	sshpass -p $sftppass SFTP -P 2222 -r $sftpuser@$server:wp-content/mysql.sql mysql.sql
}

function overwrite_database() {
	env_message=true
	wp db import mysql.sql
	wp search-replace ${replace[0]} ${replace[1]}
}

function wpe_get_plugins() {
	env_message=true
	sshpass -p $sftppass SFTP -P 2222 -r $sftpuser@$server:wp-content/plugins wp-content/
	rm -rf wp-content/plugins/hyperdb
	rm -rf wp-content/plugins/hyperdb-1-1
}

function wpe_get_uploads() {
	env_message=true
	sshpass -p $sftppass SFTP -P 2222 -r $sftpuser@$server:wp-content/uploads wp-content/
}

function run_scripts() {
	if [[ $db = true ]]; then
		wpe_get_database
		overwrite_database
	fi

	if [[ $uploads = true ]]; then
		wpe_get_uploads
	fi

	if [[ $plugins = true ]]; then
		wpe_get_plugins
	fi

	# Overwrites the database with the version on mysql.sql at root
	if [[ $overwrite = true ]]; then
		overwrite_database
	fi
}

srcdir="$(dirname "$0")"
source "$srcdir/sync-config.sh"
run_scripts

if [[ $env_message = false ]]; then
	printf "$(tput setaf 3)$(tput bold)Warning:$(tput setaf 0)$(tput sgr0) Sync failed.\n"
else
	printf "$(tput setaf 2)$(tput bold)Success:$(tput setaf 0)$(tput sgr0) ${PWD##*/} environment synced.\n"
fi
