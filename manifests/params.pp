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
  $manage_service     = true
  $devicescan         = true
  $devicescan_options = undef
  $devices            = []
  $mail_to            = 'root'
  $warning_schedule   = 'daily' # other choices: once, diminishing, exec
  $exec_script        = false
  $default_options    = undef

  $version_string = fact('smartmontools_version') ? {
    undef   => '0.0',
    default => fact('smartmontools_version'),
  }

  # smartd.conf < 5.43 does not support the 'DEFAULT' directive
  if versioncmp($version_string, '5.43') >= 0 {
    $enable_default = true
  } else {
    $enable_default = false
  }

  case fact('os.family') {
    'FreeBSD': {
      $config_file = '/usr/local/etc/smartd.conf'
      $service_name = 'smartd'
    }
    'RedHat': {
      $config_file = fact('os.name') ? {
        # lint:ignore:80chars
        'Fedora'                                       => fact('os.release.full') ? {
          # No, I am not going to support versions 1-9.
          /10|11|12|13|14|15|16|17|18/ => '/etc/smartd.conf',
          default                      => '/etc/smartmontools/smartd.conf',
        },
        /RedHat|CentOS|Scientific|SLC|OracleLinux|OEL|Rocky/ => fact('os.release.major') ? {
          /4|5|6/ => '/etc/smartd.conf',
          default => '/etc/smartmontools/smartd.conf',
        },
        default                                        => '/etc/smartd.conf',
        # lint:endignore
      }
      $service_name = 'smartd'
    }
    'SuSE': {
      $config_file = '/etc/smartd.conf'
      $service_name = 'smartd'
    }
    'Debian': {
      $config_file = '/etc/smartd.conf'
      $service_name = 'smartmontools'
    }
    default: {
      fail("Module ${module_name} is not supported on fact('os.name')}")
    }
  }
}
