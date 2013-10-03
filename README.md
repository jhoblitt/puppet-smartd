Puppet smartd Module
====================

[![Build Status](https://travis-ci.org/jhoblitt/puppet-smartd.png)](https://travis-ci.org/jhoblitt/puppet-smartd)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Usage](#usage)
    * [Version `2.x.x` _incompatilbe_ API change](#version-2xx-incompatilbe-api-change)
    * [Simple Usage](#simple-usage)
    * [Parameters](#parameters)
    * [Pedantic Example](#pedantic-example)
    * [Hiera Data Bindings](#hiera-data-bindings)
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
initially made primarily to fix support of probing `SATA` drives behind a LSI
Megaraid controllers.  The author has been aware of the fork and it's hoped
that the two modules can be merged.  Since the initial fork, a number of small
API changes have been made to improve usage.


Usage
-----

### Version `2.x.x` _incompatible_ API change

The `v2` API merges the `v1` API's `devices` and `device_options` parameters
into a single parameter named `devices`, but with incompatible semantics to the
`v1` API.

`devices` now accepts an `Array` of `Hash`.  This is to allow multiple
`smartd.conf` entries for the same blockdev as is typically required for probing
through to individual disks behind a block device presented by a RAID
controller.

#### Old `v1` API

Note that `devices` used to accept a flat `Array`.

```puppet
    class{ 'smartd':
      devices        => [ '/dev/sg1', '/dev/sg2' ],
      device_options => { '/dev/sg1' => '-o on -S on -a', '/dev/sg2' => '-o on -S on -a' },
    }
```

#### New `v2` API

`devices` now accepts an `Array` of `Hash`.

```puppet
    class{ 'smartd':
      devices => [
        { device => '/dev/sg1', options => '-o on -S on -a' },
        { device => '/dev/sg2', options => '-o on -S on -a' },
      ],
    }
```

### Simple Usage

```puppet
    include smartd
```

```puppet
    class{ 'smartd': }
```

### Parameters

All parameters are optional.

#### `ensure`

`String`

Standard Puppet ensure semantics (and supports `purged` state if your
package provider does). Valid values are:
`present`,`latest`,`absent`,`purged`

defaults to: `present`

#### `package_name`

`String`

Name of the smartmontools package.

defaults to: `smartmontools`

#### `service_name`

`String`

Name of the smartmontools monitoring daemon.

defaults to: `smartd`

#### `service_ensure`

`String`

State of the smartmontools monitoring daemon. Valid values are:
`running`,`stopped`

defaults to: `running`

#### `config_file`

`String`

Path to the configuration file for the monitoring daemon.

defaults to: (OS-specific)

#### `devicescan`

`Bool`

Sets the `DEVICESCAN` directive in the smart daemon config file. Tells the
smart daemon to automatically detect all of the SMART-capable drives in the
system.

defaults to: `true`

#### `devicescan_options`

`String`

Passes options to the `DEVICESCAN` directive. `devicescan` must equal `true`
for this to have any effect.

defaults to: `undef`

#### `devices`

`Array` of `Hash`

Explicit list of raw block devices to check. Eg.

```puppet
    [{ device => '/dev/sda', options => '-I 194' }]
```

defaults to: `[]`

#### `mail_to`

`String`

Smart daemon notifcation email address.

defaults to: `root`

#### `warning_schedule`

`String`

Smart daemon problem mail notification frequency. Valid values are:
`daily`,`once`,`diminishing`

defaults to: `daily`

### Pedantic Example

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


