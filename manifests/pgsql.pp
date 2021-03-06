# Safe PostgreSQL dumps, as part of a backupninja run.
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
#   databases, backupdir, format, vsname
#   and compress take true/false rather than yes/no.
#
define backupninja::pgsql(
  $order     = 10,
  $ensure    = present,
  $backupdir = false,
  $databases = 'all',
  $format    = 'plain',
  $compress  = 'yes',
  $vsname    = false,
) {
  include ::backupninja::client::defaults

  file { "${backupninja::client::defaults::configdir}/${order}_${name}.pgsql":
    ensure  => $ensure,
    content => template('backupninja/pgsql.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0600',
    require => File[$backupninja::client::defaults::configdir],
  }
}
