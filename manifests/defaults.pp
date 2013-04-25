class smartd::defaults {
  $autoupdate   = false
  $package_name = 'smartmontools'
  $service_name = 'smartd'
  $scan         = true
  $devices      = []
  $device_opts  = {}
  $mail_to      = 'root'
  $schedule     = 'daily'	# other choices: once, diminishing
  $enable_monit = false
  $devicescan_options = false

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
