Puppet smartd Module
====================

[![Build Status](https://travis-ci.org/jhoblitt/puppet-smartd.png)](https://travis-ci.org/jhoblitt/puppet-smartd)

#### Table of Contents

1. [Overview](#overview)
2. [Description](#description)
3. [Usage](#usage)
    * [Version `2.x.x` _incompatible_ API change](#version-2xx-incompatible-api-change)
    * [Simple Usage](#simple-usage)
    * [Parameters](#parameters)
    * [Pedantic Example](#pedantic-example)
    * [Hiera Data Bindings](#hiera-data-bindings)
    * [Facts](#facts)
4. [Limitations](#limitations)
    * [Tested Platforms](#tested-platforms)
5. [Versioning](#versioning)
6. [Support](#support)
7. [See Also](#see-also)


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
`mfiutil(8)` utility instead.

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

`String` defaults to: `present`

Standard Puppet ensure semantics (and supports `purged` state if your package
provider does). Valid values are: `present`,`latest`,`absent`,`purged`

#### `package_name`

`String` defaults to: `smartmontools`

Name of the smartmontools package.

#### `service_name`

`String` defaults to: `smartd`

Name of the smartmontools monitoring daemon.

#### `service_ensure`

`String` defaults to: `running`

State of the smartmontools monitoring daemon. Valid values are:
`running`,`stopped`

#### `config_file`

`String` defaults to: (OS-specific)

Path to the configuration file for the monitoring daemon.

#### `devicescan`

`Bool` defaults to: `true`

Sets the `DEVICESCAN` directive in the smart daemon config file. Tells the
smart daemon to automatically detect all of the SMART-capable drives in the
system.

#### `devicescan_options`

`String` defaults to: `undef`

Passes options to the `DEVICESCAN` directive. `devicescan` must equal `true`
for this to have any effect.

#### `devices`

`Array` of `Hash` defaults to: `[]`

Explicit list of raw block devices to check. Eg.

```puppet
    [{ device => '/dev/sda', options => '-I 194' }]
```

#### `mail_to`

`String` defaults to: `root`

Smart daemon notification email address.

#### `warning_schedule`

`String` defaults to: `daily`

Smart daemon problem mail notification frequency. Valid values are:
`daily`,`once`,`diminishing`, `exec`

If `exec` is selected, a value must be provided to `exec_script`.

#### `exec_script`

`String` defaults to: `false`

Path to the script that should be executed when problem mail notification
should be sent. This parameter should only be set if `warning_schedule` is set
to `exec`.

#### `enable_default`

`Bool` defaults to: `true` if `$::smartmontools_version >= 5.43`, otherwise `false`

Enables/disables the `DEFAULT` directive in the `smartd.conf` file.  This
directive was added in the 5.43 release of smartmontools and is unsupported in
previous versions.

If `enable_default` is set to `false` the the values from the [`mail_to`](#mail-to) and [`warning_schedule`](#warning-schedule) parameters are set on the `DEVICESCAN` directive (if enabled) instead of the [absent] `DEFAULT` directive.

Example `smartd.conf` content based on this setting:

`enable_default => true`
```
# Managed by Puppet -- do not edit!
DEFAULT -m root -M daily
DEVICESCAN
```

`enable_default => false`
```
# Managed by Puppet -- do not edit!
DEVICESCAN -m root -M daily
```

Here is an example of the error message generated by the `DEFFAULT` directive
appearing in the configuration file of 5.42.

```
smartd 5.42 2011-10-20 r3458 [i686-linux-2.6.18-371.6.1.el5PAE] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net
Opened configuration file /etc/smartd.conf
Drive: DEFAULT, implied '-a' Directive on line 2 of file /etc/smartd.conf
Drive: DEVICESCAN, implied '-a' Directive on line 3 of file /etc/smartd.conf
Configuration file /etc/smartd.conf was parsed, found DEVICESCAN, scanning devices
Device: DEFAULT, unable to autodetect device type
```

This option could not be named `default` to be consistent with the naming
convention of the other parameters in this module due to this bug
[PUP-2244](https://tickets.puppetlabs.com/browse/PUP-2244) that affects puppet
2.7.x.

Note that RHEL5 ships with 5.42 while RHEL6 ships with 5.43.

#### `default_options`

`String` defaults to: `undef`

Additional arguments to be set on the `DEFAULT` directive.

If `default` is set to `false`, this parameter's value will be set on the
`DEVICESCAN` directive (if enabled) instead of the [absent] `DEFAULT`
directive.

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
      default            => 'false',
      default_options    => '-H',
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

### Facts

#### `megacli`

Path to the `MegaCli` executable. Example:

    megacli => /usr/bin/MegaCli

#### `megacli_version`

Version string of the `MegaCli` executable. Example:

    megacli_version => 8.07.07

#### `megaraid_adapters`

The count of LSI MegaRAID adapters detected in the system.  *Note that this
module presently only supports a single adapter per system.* Example:

    megaraid_adapters => 1

#### `megaraid_fw_package_build`

The LSI MegaRAID adapter firmware package string.  Example:

    megaraid_fw_package_build => 23.22.0-0012

#### `megaraid_fw_version`

The LSI MegaRAID adapter firmware version string.  Example:

    megaraid_fw_version => 3.340.05-2939

#### `megaraid_physical_drives`

The LSI MegaRAID unique device ID(s) for all attached disks.  Example:

    megaraid_physical_drives => 116,117,120,121,122,123,124,125,126,127,128,129,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,200,201,202,203,204,205,206,207

#### `megaraid_physical_drives_sas`

The LSI MegaRAID unique device ID(s) for only attached *SAS* disks.  Example:

    megaraid_physical_drives_sas => 116,117,120,121,122,123,124,125,126,127,128,129,131,132,133,134,135,136,137,138,139,140,187,188,189,190,191,192,193,194,195,196,197,198,200,201,202,203,204,205,206,207

#### `megaraid_physical_drives_sata`

The LSI MegaRAID unique device ID(s) for only attached *SATA* disks.  Example:

    megaraid_physical_drives_sata => 141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186

#### `megaraid_product_name`

The LSI MegaRAID product name string.  Example:

    megaraid_product_name => LSI MegaRAID SAS 9286CV-8e

#### `megaraid_serial`

The LSI MegaRAID serial number string.  Example:

    megaraid_serial => SV22925366

#### `megaraid_virtual_drives`

A listing of `/dev/<foo>` devices exported by a LSI MegaRAID controller.  Example:

    megaraid_virtual_drives => sda,sdb,sdc,sdd,sde,sdf,sdg,sdh,sdk,sdl

#### `smartd`

Path to the `smartd` executable. Example:

    smartd => /usr/sbin/smartd

#### `smartmontools_version`

Version of the install `smartmontools` package. Example:

    smartmontools_version => 5.43


Limitations
-----------

### Tested Platforms

These are the platforms that have had integration testing since the fork.

* el6.x
* el5.x


Versioning
----------

This module is versioned according to the [Semantic Versioning
2.0.0](http://semver.org/spec/v2.0.0.html) specification.


Support
-------

Please log tickets and issues at [github](https://github.com/jhoblitt/puppet-smartd/issues)


See Also
--------

* [`smartmontools`](http://smartmontools.sourceforge.net/)
