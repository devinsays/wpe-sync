# WPE Sync

Script for running common sync tasks between your WP Engine site and local.

Requires [SSH Access](https://wpengine.com/support/getting-started-ssh-gateway/) enabled on your WP Engine account.

Assumes you have wp-cli installed locally and can run it from your local site directory.

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

d) Syncs your live database to local.

`sync/sync.sh -d`

*Overwrite Database*

o) Imports `db.sql` if one is available in your site root.

`sync/sync.sh -o`

*Sync Plugins*

p) Syncs your local `/wp-content/plugins` with the latest from remote.

`sync/sync.sh -p`

*Sync Media*

u) Syncs your local `/wp-content/uploads` with the latest from remote.

*Multiple Flags*

You can also run a combination of flags:

`sync/sync.sh -dpu`