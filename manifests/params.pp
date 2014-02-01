# == Class: smartd::params
#
# This class should be considered private.
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
  $service_ensure     = 'running'
  $devicescan         = true
  $devicescan_options = undef
  $devices            = []
  $mail_to            = 'root'
  $warning_schedule   = 'daily' # other choices: once, diminishing

  case $::osfamily {
    'FreeBSD': {
      $config_file  = '/usr/local/etc/smartd.conf'
      $service_name = 'smartd'
    }
    'RedHat': {
      $config_file  = '/etc/smartd.conf'
      $service_name = 'smartd'
    }
    'Debian': {
      $config_file  = '/etc/smartd.conf'
      $service_name = 'smartmontools'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
