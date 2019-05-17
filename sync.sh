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
	ssh -t $sshenv@$sshenv.ssh.wpengine.net bash -c "cd /sites/{$sshenv} && wp db export -" > db.sql
}

function overwrite_database() {
	env_message=true
	wp db import db.sql
	wp search-replace ${replace[0]} ${replace[1]}
}

function wpe_get_plugins() {
	env_message=true
	rsync -rvz --progress $sshenv@$sshenv.ssh.wpengine.net:/sites/$sshenv/wp-content/plugins wp-content
}

function wpe_get_uploads() {
	env_message=true
	rsync -rvz --progress $sshenv@$sshenv.ssh.wpengine.net:/sites/$sshenv/wp-content/uploads wp-content
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
	printf "$(tput setaf 2)$(tput bold)Success:$(tput setaf 0)$(tput sgr0) ${sshenv} environment synced.\n"
fi
