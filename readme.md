# WPE Sync

Bash script for automating common tasks on WP Engine, such as SFTP file downloads and database local database syncing.

### Installation

1. Go to the root directory of your WordPress install (assumes the `wp-content` is located here).
2. Make a "sync" directory: `mkdir sync`
3. Clone this repo into "sync": `git clone git@github.com:devinsays/wpe-sync.git sync`
4. Make the bash scripts executable:
	* `chmod +x sync/sync.sh`
	* `chmod +x sync/sync-config.sh`
5. Add your credentials in `sync/sync-config.sh`

### Syncing

The following flags are available:

*Sync Database*

d) Downloads a copy of `mysql.sql` and imports it.

`sync/sync.sh -d`

*Overwrite Database*

o) Imports `mysql.sql` if one is available in the `sync` directory.

`sync/sync.sh -o`

*Sync Plugins*

p) Overwrites your local `/wp-content/plugins` with the latest from remote.

`sync/sync.sh -p`

*Sync Media*

u) Overwrites your local `/wp-content/media` with the latest from remote.

*Multiple Flags*

You can also run a combination of flags:

`sync/sync.sh -dpu`

### Troubleshooting

If you are connecting to a host for the first time, you may need to add the host to your list of known_hosts. If you also use an SFTP tool like Transmit, the easiest way might be to connect to the host first with Transmit as this add to known_hosts automatically for you.