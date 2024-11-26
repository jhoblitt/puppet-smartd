# == Class: smartd
#
# Manages the smartmontools package including the smartd daemon
#
# [*smartd_opts*]
#   `String`
#
#   Command line options for `smartd(8)` startup.  Only has an effect if
#   `$manage_smartd_opts` is set to `true`.
#
#   defaults to: (OS-specific)
#
# [*manage_smartd_opts*]
#   `Bool`
#
#   Enable or disable management of `smartd(8)` command line options
#   (`$smartd_opts`).
#
#   defaults to: false
#
# === Parameters
#
# All parameters are optional.
#
# [*ensure*]
#  `String`
#
#   Standard Puppet ensure semantics (and supports `purged` state if your
#   package provider does). Valid values are:
#   `present`,`latest`,`absent`,`purged`
#
#   defaults to: `present`
#
# [*package_name*]
#   `String`
#
#   Name of the smartmontools package.
#
#   defaults to: `smartmontools`
#
# [*service_name*]
#  `String`
#
#   Name of the smartmontools monitoring daemon.
#
#   defaults to: `smartd`
#
# [*service_ensure*]
#  `String`
#
#   State of the smartmontools monitoring daemon. Valid values are:
#   `running`,`stopped`
#
#   defaults to: `running`
#
# [*manage_service*]
#  `Bool`
#
#   State whether or not this puppet module should manage the service.
#   This parameter is disregarded when $ensure = absent|purge.
#
#   defaults to: `true`
#
# [*config_file*]
#   `String`
#
#   Path to the configuration file for the monitoring daemon.
#
#   defaults to: (OS-specific)
#
# [*devicescan*]
#   `Bool`
#
#   Sets the `DEVICESCAN` directive in the smart daemon config file.  Tells the
#   smart daemon to automatically detect all of the SMART-capable drives in the
#   system.
#
#   defaults to: `true`
#
# [*devicescan_options*]
#   `String`
#
#   Passes options to the `DEVICESCAN` directive.  `devicescan` must equal true
#   for this to have any effect.
#
#   defaults to: `undef`
#
# [*devices*]
#   `Array` of `Hash`
#
#   Explicit list of raw block devices to check.  Eg.
#    [{ device => '/dev/sda', options => '-I 194' }]
#
#   defaults to: `[]`
#
# [*mail_to*]
#   `String`
#
#   Smart daemon notifcation email address.
#
#   defaults to: `root`
#
# [*warning_schedule*]
#   `String`
#
#   Smart daemon problem mail notification frequency. Valid values are:
#   `daily`,`once`,`diminishing`, `exec`
#
#   Note that if the value `exec` is used, then the parameter `exec_script`
#   *must* be specified.
#
#   defaults to: `daily`
#
# [*exec_script*]
#   `String`
#
#   Script that should be executed if warning_schedule is set to `exec`.
#
#   defaults to: `undef`
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
  $service_name       = $smartd::params::service_name,
  $service_ensure     = $smartd::params::service_ensure,
  $manage_service     = $smartd::params::manage_service,
  $config_file        = $smartd::params::config_file,
  $devicescan         = $smartd::params::devicescan,
  $devicescan_options = $smartd::params::devicescan_options,
  $devices            = $smartd::params::devices,
  $mail_to            = $smartd::params::mail_to,
  $warning_schedule   = $smartd::params::warning_schedule,
  $exec_script        = $smartd::params::exec_script,
  $enable_default     = $smartd::params::enable_default,
  $default_options    = $smartd::params::default_options,
  $smartd_opts        = $smartd::params::smartd_opts,
  $manage_smartd_opts = $smartd::params::manage_smartd_opts,
) inherits smartd::params {
  validate_re($ensure, '^present$|^latest$|^absent$|^purged$')
  validate_string($package_name)
  validate_string($service_name)
  validate_re($service_ensure, '^running$|^stopped$')
  validate_string($config_file)
  validate_bool($devicescan)
  validate_string($devicescan_options)
  validate_array($devices)
  validate_string($mail_to)
  validate_re($warning_schedule, '^daily$|^once$|^diminishing$|^exec$',
    '$warning_schedule must be either daily, once, diminishing, or exec.')
  if $warning_schedule == 'exec' {
    if $exec_script == false {
      fail('$exec_script must be set when $warning_schedule is set to exec.')
    }
    $real_warning_schedule = "${warning_schedule} ${exec_script}"
  }
  else {
    if $exec_script != false {
      fail('$exec_script should not be used when $warning_schedule is not set to exec.')
    }
    $real_warning_schedule = $warning_schedule
  }
  validate_bool($enable_default)
  validate_string($default_options)
  validate_string($smartd_opts)
  validate_bool($manage_smartd_opts)

  case $ensure {
    'present', 'latest': {
      $pkg_ensure  = $ensure
      $svc_ensure  = $service_ensure
      $svc_enable  = $service_ensure ? { 'running' => true, 'stopped' => false }
      $file_ensure = 'present'
      $srv_manage  = $manage_service
    }
    'absent', 'purged': {
      $pkg_ensure  = $ensure
      $svc_ensure  = 'stopped'
      $svc_enable  = false
      $file_ensure = 'absent'
      $srv_manage  = false
    }
    default: {
      fail("unsupported value of \$ensure: ${ensure}")
    }
  }

  package { $package_name:
    ensure => $pkg_ensure,
  }

  if $srv_manage {
    service { $service_name:
      ensure     => $svc_ensure,
      enable     => $svc_enable,
      hasrestart => true,
      hasstatus  => true,
      subscribe  => File[$config_file],
    }

    Package[$package_name] -> Service[$service_name]
  }

  file { $config_file:
    ensure  => $file_ensure,
    owner   => 'root',
    group   => $::gid,
    mode    => '0644',
    content => template('smartd/smartd.conf'),
    require => Package[$package_name],
  }

  if $ensure == purged {
    $var_lib_ensure = 'absent'
    $var_lib_force  = true
  } else {
    $var_lib_ensure = 'directory'
  }

  file { '/var/lib/smartmontools':
    ensure => $var_lib_ensure,
    force  => $var_lib_force,
    owner  => 'root',
    group  => '0',
    mode   => '0755',
  }

  # Special sauce for Debian where it's not enough for the rc script
  # to be enabled, it also needs its own extra special config file.
  if $::osfamily == 'Debian' {
    $debian_augeas_changes = $svc_enable ? {
      false   => 'remove start_smartd',
      default => 'set start_smartd "yes"',
    }

    augeas { 'shell_config_start_smartd':
      lens    => 'Shellvars.lns',
      incl    => '/etc/default/smartmontools',
      changes => $debian_augeas_changes,
      require => Package[$package_name],
    }

    if $srv_manage {
      Augeas['shell_config_start_smartd'] {
        before => Service[$service_name]
      }
    }
  }
}
