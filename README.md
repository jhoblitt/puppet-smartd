Puppet smartd Module
====================

Description
-----------

This is the `smartd` module and class.  It configures the `smartd` daemon,
which comes with smartmontools, and works on FreeBSD and Debian-ish Linux
systems.  If your hardware supports it, smartd can automatically probe for the
drives, but if they are hidden behind a RAID controller, it will need
additional help.  The module includes a facter plugin to identify drives hiding
behind an LSI MegaRAID/Dell PERC controller on Linux systems if you have the
LSI proprietary `MegaCli` tool installed; we don't have any FreeBSD machines
with this controller so haven't written the necessary code to use FreeBSD's
standard mfiutil(8) utility instead.  The `shell_config` module is required to
edit a Debian-specific configuration file; other OS families do not require it.

The module automatically configures a virtual `monit::monitor` resource (tag =>
default) to keep track of `smartd`.  Note that `smartd` can take a very long
time to (re)start, so if you have a large number of disk devices (e.g., 200 on
a big ZFS file server) you will need to adjust `monit`'s startup delay.

Currently, drives behind an LSI MegaRAID controller will be automatically
probed and added to the `smartd` configuration file, if the `MegaCli` utility
is installed.  There is no way to turn this behavior off.  This is arguably a
bug.

Examples
--------

### Basic Usage

    class{ 'smartd': }


Support
-------

Please log tickets and issues at [github](https://github.com/jhoblitt/puppet-smartd/issues)

License
-------
See the file LICENSE.

Contact
-------
Joshua Hoblitt <jhoblitt@cpan.org>
