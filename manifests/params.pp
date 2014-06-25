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
  $default_options    = undef

  # smartd.conf < 5.43 does not support the 'DEFAULT' directive
  if versioncmp($::smartmontools_version, 5.43) >= 0 {
    $enable_default = true
  } else {
    $enable_default = false
  }

  case $::osfamily {
    'FreeBSD': {
      $config_file = '/usr/local/etc/smartd.conf'
	  $service_name = 'smartd'
    }
    'RedHat', 'SuSE': {
      $config_file = '/etc/smartd.conf'
	  $service_name = 'smartd'
    }
    'Debian': {
      $config_file = '/etc/smartd.conf'
	  $service_name = 'smartmontools'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
