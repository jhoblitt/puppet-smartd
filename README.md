Puppet smartd Module
====================

[![Build Status](https://travis-ci.org/jhoblitt/puppet-smartd.png)](https://travis-ci.org/jhoblitt/puppet-smartd)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Usage](#usage)
4. [Limitations](#limitations)
    * [Tested Platforms](#tested-platforms)
5. [Support](#support)


Overview
--------

Manages the smartmontools package including the smartd daemon


Description
-----------

Installs the [`smartmontools`](http://smartmontools.sourceforge.net/) package
and enables the `smartd` service.

If your hardware supports it, `smartd` can automatically probe for the drives,
but if they are hidden behind a RAID controller, it will need additional help.
The module includes a facter plugin to identify drives hiding behind an LSI
MegaRAID/Dell PERC/Supermicro controller on Linux systems if you have the LSI
proprietary `MegaCli` tool installed; we don't have any FreeBSD machines with
this controller so haven't written the necessary code to use FreeBSD's standard
`mfiutil(8)` utility instead.  The `shell_config` module is required to edit a
Debian-specific configuration file; other OS families do not require it.

Currently, drives behind an LSI MegaRAID controller will be automatically
probed and added to the `smartd` configuration file, if the `MegaCli` utility
is installed.  There is no way to turn this behavior off.  This is arguably a
bug.

It is planned that in a future release the `megaraid` specific facts will be
migrated into the
[`puppet-megaraid`](https://github.com/jhoblitt/puppet-megaraid) module.

### Forked

This is a fork of
[`csail/smartd`](http://tig.csail.mit.edu/wiki/TIG/PuppetAtCSAIL) that was
intially made primarily to fix support of probing `SATA` drives behind a LSI
Megaraid controllers.  The author has been aware of the fork and it's hoped
that the two module can be merged.  Since the initial fork, a number of small
API changes have been made to improve usage.


Usage
-----

### Basic Usage

```puppet
    include smartd
```

```puppet
    class{ 'smartd': }
```

### All Parameters

```puppet
    class{ 'smartd':
      ensure             => 'present',
      package_name       => 'smartmontools',
      service_name       => 'smartd',
      service_ensure     => 'running',
      config_file        => '/etc/smartd.conf',
      devicescan         => true,
      devicescan_options => '-H -m admin@example.com',
      devices            => [
        { device => '/dev/sg1', options => '-o on -S on -a' },
        { device => '/dev/sg2', options => '-o on -S on -a' },
      ],
      mail_to            => 'root',
      warning_schedule   => 'diminishing',
    }
```

### Hiera Data Bindings

```yaml
---
smartd::mail_to: "root@%{::domain}"
smartd::devicescan: false
smartd::devices:
  -
    device: '/dev/cciss/c0d0'
    options: '-d cciss,0 -a -o on -S on -s (S/../.././19|L/../../3/21)'
  -
    device: '/dev/cciss/c0d0'
    options: '-d cciss,1 -a -o on -S on -s (S/../.././18|L/../../3/20)'
  -
    device: '/dev/sda'
    options: '-a -o on -S on -s (S/../.././18|L/../../3/20|C/../.././19)'
```


Limitations
-----------

### Tested Platforms

These are the platforms that have had integration testing since the fork.

* el6.x


Support
-------

Please log tickets and issues at [github](https://github.com/jhoblitt/puppet-smartd/issues)


