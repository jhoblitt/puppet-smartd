# == Class: smartd::params
#
# Provides parameters for the smartd module
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
class smartd::params {
  $package_name       = 'smartmontools'
  $service_name       = 'smartd'
  $service_ensure     = 'running'
  $devicescan         = true
  $devicescan_options = false
  $devices            = []
  $device_opts        = {}
  $mail_to            = 'root'
  $warning_schedule   = 'daily' # other choices: once, diminishing
  $enable_monit       = false

  case $::osfamily {
    'FreeBSD': {
      $config_file = '/usr/local/etc/smartd.conf'
    }
    'Debian', 'RedHat': {
      $config_file = '/etc/smartd.conf'
    }
    default: { fail("smartd: unsupported OS family ${::osfamily}}") }
  }
}
