class smartd ($ensure       = 'present',
              $autoupdate   = $smartd::defaults::autoupdate,
              $package_name = $smartd::defaults::package_name,
              $service_name = $smartd::defaults::service_name,
              $config_file  = $smartd::defaults::config_file,
              $scan         = $smartd::defaults::scan,
              $devices      = $smartd::defaults::devices,
              $device_opts  = $smartd::defaults::device_opts,
              $mail_to      = $smartd::defaults::mail_to,
              $schedule     = $smartd::defaults::schedule,
              $enable_monit = $smartd::defaults::enable_monit,
             ) inherits smartd::defaults {
  case $ensure {
    'present': {
      if $autoupdate {
        $pkg_ensure = 'latest'
      } else {
        $pkg_ensure = 'present'
      }
      $svc_ensure   = 'running'
      $svc_enable   = true
      $file_ensure  = 'present'
    }
    'absent': {
      $pkg_ensure = 'absent'
      $svc_ensure   = 'stopped'
      $svc_enable   = false
      $file_ensure   = 'absent'
    }
    'purged': {
      $pkg_ensure = 'purged'
      $svc_ensure   = 'stopped'
      $svc_enable   = false
      $file_ensure   = 'absent'
    }
  }

  package {$package_name:
    ensure     => $pkg_ensure,
  } -> service {$service_name:
    ensure     => $svc_ensure,
    enable     => $svc_enable,
    hasrestart => true,
  }

  file {$config_file:
    ensure  => $file_present,
    owner   => root,
    group   => 0,
    mode    => 0644,
    content => template('smartd/smartd.conf'),
    require => Package[$package_name],
    before  => Service[$service_name],
  }

  # Special sauce for Debian where it's not enough for the rc script
  # to be enabled, it also needs its own extra special config file.
  if $::osfamily == 'Debian' {
    shell_config {'start_smartd':
      file   => '/etc/default/smartmontools',
      key    => 'start_smartd',
      value  => 'yes',
      ensure => $file_ensure,
      before => Service[$service_name],
    }
  }

  # Let monit monitor smartd, if configured.
  if $enable_monit {
    @monit::monitor {$service_name:
      pidfile => "/var/run/${service_name}.pid",
      ensure  => $file_present,
      tag     => 'default',
    }
  }
}
