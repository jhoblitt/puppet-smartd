# == Class: smartd
#
# install and configure the smartmontools monitoring daemon
#
# === Parameters
#
# All parameteres are optional.
#
# [*ensure*]
#   String.
#
#   Standard Puppet ensure semantics (and supports `purged` state if your
#   package provider does). Valid values are: '^present$|^latest$|^absent$|^purged$'
#
#   defaults to: `present`
#
# [*package_name*]
#   String.
#
#   Name of the smartmontools package.
#
#   defaults to: 'smartmontools'
#
# [*service_name*]
#   String.
#
#   Name of the smartmontools monitoring daemon.
#
#   defaults to: 'smartd'
#
# [*service_ensure*]
#   String.
#
#   State of the smartmontools monitoring daemon.  Valid values are:
#   '^running$|^stopped$'
#
#   defaults to: 'running'
#
# [*config_file*]
#   String.
#
#   Path to the configuration file for the monitoring daemon.
#
#   defaults to: (OS-specific)
#
# [*devicescan*]
#   Boolean.
#
#   Sets the `DEVICESCAN` directive in the smart daemon config file.  Tells the
#   smart daemon to automatically detect all of the SMART-capable drives in the
#   system.
#
#   defaults to: true
#
# [*devicescan_options*]
#   String.
#
#   Passes options to the `DEVICESCAN` directive.  *devicescan* must equal true
#   for this to have any effect.
#
#   defaults to: ''
#
# [*devices*]
#   Array of Strings.
#
#   Explicit list of raw block devices to check.  Eg.
#     ['/dev/sda', '/dev/sdb']
#
#   defaults to: []
#
# [*device_opts*]
#   Hash.
#
#   List of options to pass to a specific device.  Eg.
#     { '/dev/sda' => '-H -l error -l selftest -t -I 194' }
#
#   defaults to: {}
#
# [*mail_to*]
#   String.
#
#   Smart daemon notifcation email address.
#
#   defaults to: 'root'
#
# [*warning_schedule*]
#   String.
#
#   Smart daemon problem notification frequency.
#
#   defaults to: 'daily'
#
# [*enable_monit*]
#   Boolean.
#
#   Enable integration with the monitor module:
#     http://tig.csail.mit.edu/git-public/monit.git/
#
#   defaults to: false
#
# === Authors
#
# MIT Computer Science & Artificial Intelligence Laboratory
# Joshua Hoblitt <jhoblitt@cpan.org>
#
# === Copyright
#
# Copyright 2012 Massachusetts Institute of Technology
# Copyright (C) 2013 Joshua Hoblitt
#
class smartd (
  $ensure             = 'present',
  $package_name       = $smartd::params::package_name,
  $config_file        = $smartd::params::config_file,
  $service_ensure     = $smartd::params::service_ensure,
  $devicescan         = $smartd::params::devicescan,
  $devicescan_options = $smartd::params::devicescan_options,
  $devices            = $smartd::params::devices,
  $device_opts        = $smartd::params::device_opts,
  $mail_to            = $smartd::params::mail_to,
  $warning_schedule   = $smartd::params::warning_schedule,
  $enable_monit       = $smartd::params::enable_monit,
) inherits smartd::params {
  validate_re($ensure, '^present$|^latest$|^absent$|^purged$')
  validate_re($service_ensure, '^running$|^stopped$')

  # Validate our booleans
  validate_bool($devicescan)
  validate_bool($enable_monit)

  # Validate our hashs
  validate_hash($device_opts)

  # Validate our regexs
  $states = [ '^daily$', '^once$', '^diminishing$', ]
  validate_re($warning_schedule, $states,
    '$warning_schedule must be either daily, once, or diminishing.')

  case $ensure {
    'present','latest': {
      $pkg_ensure  = $ensure
      $svc_ensure  = $service_ensure
      $svc_enable  = $service_ensure ? { 'running' => true, 'stopped' => false }
      $file_ensure = 'present'
    }
    'absent','purged': {
      $pkg_ensure  = $ensure
      $svc_ensure  = 'stopped'
      $svc_enable  = false
      $file_ensure = 'absent'
    }
    default: {
      fail("unsupported value of \$ensure: ${ensure}")
    }
  }

  package {$package_name:
    ensure => $pkg_ensure,
  }

  service {$service_name:
    ensure     => $svc_ensure,
    enable     => $svc_enable,
    hasrestart => true,
    hasstatus  => true,
  }

  Package[$package_name] -> Service[$service_name]

  file {$config_file:
    ensure  => $file_ensure,
    owner   => root,
    group   => 0,
    mode    => '0644',
    content => template('smartd/smartd.conf'),
    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  # Special sauce for Debian where it's not enough for the rc script
  # to be enabled, it also needs its own extra special config file.
  if $::osfamily == 'Debian' {
    shell_config {'start_smartd':
      ensure => $file_ensure,
      file   => '/etc/default/smartmontools',
      key    => 'start_smartd',
      value  => 'yes',
      before => Service[$service_name],
    }
  }

  # Let monit monitor smartd, if configured.
  if $enable_monit {
    @monit::monitor {$service_name:
      ensure  => $file_ensure,
      pidfile => "/var/run/${service_name}.pid",
      tag     => 'default',
    }
  }
}
