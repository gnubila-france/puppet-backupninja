# Run rdiff-backup as part of a backupninja run.
#
# Valid attributes for this type are:
#
#   order: The prefix to give to the handler config filename, to set
#      order in which the actions are executed during the backup run.
#
#   ensure: Allows you to delete an entry if you don't want it any more
#      (but be sure to keep the configdir, name, and order the same, so
#      that we can find the correct file to remove).
#
#   keep, include, exclude, type, host, directory, user, sshoptions: As
#      defined in the backupninja documentation.  The options will be placed
#      in the correct sections automatically.  The include and exclude
#      options should be given as arrays if you want to specify multiple
#      directories.
# 
define backupninja::rdiff($order = 90,
                           $ensure = present,
                           $user = false,
                           $directory = false,
                           $host = false,
                           $type = 'local',
                           $exclude = [ "/home/*/.gnupg", "/home/*/.local/share/Trash", "/home/*/.Trash", "/home/*/.thumbnails", "/home/*/.beagle", "/home/*/.aMule", "/home/*/gtk-gnutella-downloads" ],
                           $include = [ "/var/spool/cron/crontabs", "/var/backups", "/etc", "/root", "/home", "/usr/local/*bin", "/var/lib/dpkg/status*" ],
                           $keep = 30,
                           $sshoptions = false,
                           $options = false
                          ) {
	include backupninja::client
	case $type {
	        'remote': {
			case $host { false: { err("need to define a host for remote backups!") } }
		        backupninja::server::sandbox { $user: host => $host, dir => $directory }
		}
	}
	file { "${backupninja::client::configdir}/${order}_${name}.rdiff":
		ensure => $ensure,
		content => template('backupninja/rdiff.conf.erb'),
		owner => root,
		group => root,
		mode => 0600,
		require => File["${backupninja::client::configdir}"]
	}
}