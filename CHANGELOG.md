
#### [Current]
 * [2689cb1](../../commit/2689cb1) - __(Joshua Hoblitt)__ Merge pull request [#34](../../issues/34) from solarkennedy/debian_support

Added debian support and working tests. Closes [#32](../../issues/32)
 * [5554213](../../commit/5554213) - __(Kyle Anderson)__ Added debian support and working tests. Closes [#32](../../issues/32)
 * [962c878](../../commit/962c878) - __(Joshua Hoblitt)__ Merge pull request [#33](../../issues/33) from pauloconnor/after_package

Allow the service to start only after the package is installed
 * [db01583](../../commit/db01583) - __(Paul O'Connor)__ Allow the service to start only after the package is installed

#### v2.2.2
 * [41b6cbc](../../commit/41b6cbc) - __(Joshua Hoblitt)__ Merge pull request [#31](../../issues/31) from jhoblitt/feature/v2.2.2

bump version to v2.2.2
 * [9ab316a](../../commit/9ab316a) - __(Joshua Hoblitt)__ bump version to v2.2.2
 * [97af513](../../commit/97af513) - __(Joshua Hoblitt)__ Merge pull request [#30](../../issues/30) from jhoblitt/feature/megaraid_facts

update megaraid_serial fact to deal with SM motherboards
 * [9d2d44b](../../commit/9d2d44b) - __(Joshua Hoblitt)__ add megacli output example provided in issue [#29](../../issues/29)
 * [ebf88cd](../../commit/ebf88cd) - __(Joshua Hoblitt)__ update megaraid_serial fact to deal with SM motherboards

Per [#29](../../issues/29), the LSI controller on at least some models of SuperMicro
motherboards does not report a serial number.  The megaraid_serial fact
has not gracefully handling this case and facter was generating errors.

 * [34ccdd4](../../commit/34ccdd4) - __(Joshua Hoblitt)__ fix MD markup typos in README

#### v2.2.1
 * [2a9db83](../../commit/2a9db83) - __(Joshua Hoblitt)__ Merge pull request [#28](../../issues/28) from jhoblitt/feature/v2.2.1

bump version to v2.2.1
 * [705cb16](../../commit/705cb16) - __(Joshua Hoblitt)__ bump version to v2.2.1
 * [c870d59](../../commit/c870d59) - __(Joshua Hoblitt)__ Merge pull request [#27](../../issues/27) from jhoblitt/feature/megaraid_facts

add `-NoLog` flag to all invocations of `megacli`
 * [ea4af30](../../commit/ea4af30) - __(Joshua Hoblitt)__ tweak README formatting of facts (again)
 * [b6722ec](../../commit/b6722ec) - __(Joshua Hoblitt)__ tweak README formatting of facts
 * [deef545](../../commit/deef545) - __(Joshua Hoblitt)__ add all module supplied facts to README

Per issue [#24](../../issues/24)

 * [4678256](../../commit/4678256) - __(Joshua Hoblitt)__ add `-NoLog` flag to all invocations of `megacli`

To suppress the `/MegaSAS.log` file from being created by the megaraid
related facts, per issue [#25](../../issues/25).

 * [4ababa9](../../commit/4ababa9) - __(Joshua Hoblitt)__ work around travis switching to REE for ruby 1.8.7

See https://github.com/travis-ci/travis-ci/issues/2217

Many thanks to @dominic for sharing this on the puppet-dev channel!

 * [bacdf0e](../../commit/bacdf0e) - __(Joshua Hoblitt)__ Merge pull request [#26](../../issues/26) from lrupp/master

Add default params for SUSE
 * [6ad96f1](../../commit/6ad96f1) - __(Lars Vogdt)__ Add default params for SUSE

SUSE uses the same params as Debian and RedHat.

#### v2.2.0
 * [3775d43](../../commit/3775d43) - __(Joshua Hoblitt)__ bump version to v2.2.0
 * [b92efd9](../../commit/b92efd9) - __(Joshua Hoblitt)__ Merge pull request [#23](../../issues/23) from jhoblitt/feature/megaraid_facts

Feature/megaraid facts
 * [04d71cc](../../commit/04d71cc) - __(Joshua Hoblitt)__ add megaraid_fw_version fact
 * [2d12260](../../commit/2d12260) - __(Joshua Hoblitt)__ add megaraid_fw_package_build fact
 * [7358769](../../commit/7358769) - __(Joshua Hoblitt)__ add megaraid_serial fact
 * [512d90e](../../commit/512d90e) - __(Joshua Hoblitt)__ add megaraid_product_name fact
 * [f575189](../../commit/f575189) - __(Joshua Hoblitt)__ add megacli_version fact
 * [e7d78b5](../../commit/e7d78b5) - __(Joshua Hoblitt)__ add el5.x to the tested platforms list

#### v2.1.0
 * [19e67a4](../../commit/19e67a4) - __(Joshua Hoblitt)__ bump version to v2.1.0
 * [333d20a](../../commit/333d20a) - __(Joshua Hoblitt)__ Merge pull request [#22](../../issues/22) from jhoblitt/feature/megaraid_facts

add megaraid_physical_drives_{sata,sas} facts
 * [824e086](../../commit/824e086) - __(Joshua Hoblitt)__ change smartd.conf ERB to use megaraid_physical_drives_{sas,sata} facts

This modification add ssupport for polling the SMART values of SAS
drives behind a MegaRAID controller.  The `megaraid_physical_drives`
fact is no longer used internally by this module.

 * [29e6a16](../../commit/29e6a16) - __(Joshua Hoblitt)__ add megaraid_physical_drives_{sata,sas} facts
 * [4f558f2](../../commit/4f558f2) - __(Joshua Hoblitt)__ Merge pull request [#21](../../issues/21) from jhoblitt/feature/smartd_conf_default

Feature/smartd conf default
 * [aad6db6](../../commit/aad6db6) - __(Joshua Hoblitt)__ rename $default param to smartd class to $enable_default

To work around this bug in Puppet 2.7.x: https://tickets.puppetlabs.com/browse/PUP-2244

 * [ff61535](../../commit/ff61535) - __(Joshua Hoblitt)__ add $default_options param to smartd class

+ fix a few typos in README.md

 * [a51ca20](../../commit/a51ca20) - __(Joshua Hoblitt)__ add $default param to smartd class
 * [365a6ab](../../commit/365a6ab) - __(Joshua Hoblitt)__ Merge pull request [#20](../../issues/20) from jhoblitt/feature/smartmon_facts

Feature/smartmon facts
 * [60a2988](../../commit/60a2988) - __(Joshua Hoblitt)__ add smartmontools_version fact
 * [57af86d](../../commit/57af86d) - __(Joshua Hoblitt)__ do not confine smartd fact to linux
 * [8cbfc2b](../../commit/8cbfc2b) - __(Joshua Hoblitt)__ add smartd fact

Fact for the path to the smartd executable.

 * [0950ccb](../../commit/0950ccb) - __(Joshua Hoblitt)__ Merge pull request [#19](../../issues/19) from jhoblitt/feature/boilerplate_update

Feature/boilerplate update
 * [6ea41b2](../../commit/6ea41b2) - __(Joshua Hoblitt)__ tidy Rakefile formatting
 * [293eda0](../../commit/293eda0) - __(Joshua Hoblitt)__ update LICENSE copyright notice
 * [521a114](../../commit/521a114) - __(Joshua Hoblitt)__ update travis matrix
 * [4bf961c](../../commit/4bf961c) - __(Joshua Hoblitt)__ update .gitignore
 * [860edc7](../../commit/860edc7) - __(Joshua Hoblitt)__ Merge pull request [#18](../../issues/18) from razorsedge/MegaCli_NoLog

Added -NoLog to MegaCli commandline in facts.
 * [f9b95b0](../../commit/f9b95b0) - __(Michael Arnold)__ Include rspec test updates.
 * [1a7eb16](../../commit/1a7eb16) - __(Michael Arnold)__ Added -NoLog to MegaCli commandline in facts.

This keeps the MegaSas.log file from showing up any time factor is run.

 * [a903ee1](../../commit/a903ee1) - __(Joshua Hoblitt)__ update README formatting + boilerplate
 * [1d5dc37](../../commit/1d5dc37) - __(Joshua Hoblitt)__ Merge pull request [#15](../../issues/15) from jhoblitt/rspec-system-updates

update rspec-system boilerplate
 * [60de1c5](../../commit/60de1c5) - __(Joshua Hoblitt)__ update rspec-system boilerplate
 * [edf71eb](../../commit/edf71eb) - __(Joshua Hoblitt)__ Merge pull request [#14](../../issues/14) from jhoblitt/refactor_facts

refactor megaraid facts + add fact tests
 * [2076ecc](../../commit/2076ecc) - __(Joshua Hoblitt)__ trim travis test matrix
 * [23f1348](../../commit/23f1348) - __(Joshua Hoblitt)__ add :require => false to all Gemfile gems
 * [720a1de](../../commit/720a1de) - __(Joshua Hoblitt)__ fix rspec-puppet 1.0.1 deprecation warning

DEPRECATION: include_class is deprecated. Use contain_class instead.

 * [0d15b7e](../../commit/0d15b7e) - __(Joshua Hoblitt)__ refactor megaraid facts + add fact tests

* stop checking for megaraid `/dev/*` files and instead let megacli tell us if it can find any raid controllers
* use blockdevice facts instead of exec'ing `lsscsi`, inspired by Kyle Anderson's [gist](https://gist.github.com/solarkennedy/7606943)
* split each fact into it's own .rb file
* add rspec test coverage of all facts
* remove non-functioning freebsd facts completely

 * [dbdbd4a](../../commit/dbdbd4a) - __(Joshua Hoblitt)__ fix whitespace for linter

#### v2.0.0
 * [e044951](../../commit/e044951) - __(Joshua Hoblitt)__ bump version to v2.0.0
 * [6cbd702](../../commit/6cbd702) - __(Joshua Hoblitt)__ synx up smartd comments with README
 * [afd6759](../../commit/afd6759) - __(Joshua Hoblitt)__ note v2 API changes + full parameter list in README
 * [66c4157](../../commit/66c4157) - __(Joshua Hoblitt)__ Merge pull request [#11](../../issues/11) from razorsedge/supermicro

add megaraid fact support for Supermicro branded LSI controllers
 * [16045b6](../../commit/16045b6) - __(Joshua Hoblitt)__ Merge pull request [#12](../../issues/12) from razorsedge/hiera

Add example Hiera data bindings to README.md.
 * [fe0c07d](../../commit/fe0c07d) - __(Michael Arnold)__ Mention support of Supermicro branded MegaRAID controllers.
 * [56b40b3](../../commit/56b40b3) - __(Michael Arnold)__ Add example Hiera data bindings to README.md.
 * [aadbcef](../../commit/aadbcef) - __(Michael Arnold)__ Also look for Supermicro-branded controllers.
 * [f107cc2](../../commit/f107cc2) - __(Joshua Hoblitt)__ Merge pull request [#9](../../issues/9) from jhoblitt/merge_devices_and_device_options

merge class smartd $devices and $device_options -> $devices
 * [b2bb897](../../commit/b2bb897) - __(Joshua Hoblitt)__ merge class smartd $devices and $device_options -> $devices

$devices is now accepts and Array of Hash.  This is to allow multiple
smartd.conf entires for the same blockdev as is typically required for probing
through to individual disks behind a block device presented by a RAID
controller.

 * [6029324](../../commit/6029324) - __(Joshua Hoblitt)__ add rspec-system-puppet infrastructure + basic system tests

#### v1.0.2
 * [1f34762](../../commit/1f34762) - __(Joshua Hoblitt)__ bump version to v1.0.2
 * [40cb57a](../../commit/40cb57a) - __(Joshua Hoblitt)__ lint ignore 'pkg/**/*.pp'

#### v1.0.1
 * [23b05cd](../../commit/23b05cd) - __(Joshua Hoblitt)__ bump version to v1.0.1
 * [244e7fe](../../commit/244e7fe) - __(Joshua Hoblitt)__ add puppet 3.3.0 to travis test matrix
 * [ccb590c](../../commit/ccb590c) - __(Joshua Hoblitt)__ reduce stdlib requirement to 3.0.0
 * [9968ba4](../../commit/9968ba4) - __(Joshua Hoblitt)__ add github flavored markdown syntax highlighting to README
 * [535b835](../../commit/535b835) - __(Joshua Hoblitt)__ start using shared_examples in rspec

to try to reduce duplicate test statements

#### v1.0.0
 * [3a2d8d2](../../commit/3a2d8d2) - __(Joshua Hoblitt)__ README typo
 * [bc1eaa3](../../commit/bc1eaa3) - __(Joshua Hoblitt)__ README markdown tweaks
 * [6e9121f](../../commit/6e9121f) - __(Joshua Hoblitt)__ rename $device_opts to $device_options

For naming consistency with $devicescan_options

 * [9c9564c](../../commit/9c9564c) - __(Joshua Hoblitt)__ fix rspec-puppet syntax to work with ruby 1.8.7 (again)
 * [10d7489](../../commit/10d7489) - __(Joshua Hoblitt)__ fix rspec-puppet syntax to work with ruby 1.8.7
 * [7c27501](../../commit/7c27501) - __(Joshua Hoblitt)__ README/doc cleanup
 * [2a24156](../../commit/2a24156) - __(Joshua Hoblitt)__ tidy up smartd.conf content tests based on megaraid facts
 * [819db0b](../../commit/819db0b) - __(Joshua Hoblitt)__ set group ownership to 'root' instead of 0
 * [8b17d03](../../commit/8b17d03) - __(Joshua Hoblitt)__ update unsupported OS fail string
 * [4c8828e](../../commit/4c8828e) - __(Joshua Hoblitt)__ trivial ws consistency fixes`
 * [a068b7a](../../commit/a068b7a) - __(Joshua Hoblitt)__ fix lint warnings
 * [09fb9d8](../../commit/09fb9d8) - __(Joshua Hoblitt)__ [re-]add[?] class smart $service_name param
 * [4c0ef6e](../../commit/4c0ef6e) - __(Joshua Hoblitt)__ validate all class smartd params
 * [cede61e](../../commit/cede61e) - __(Joshua Hoblitt)__ remove monit integration

Not setup to test integration and it's unknown if this functionality is working.  Support should be re-added with integration tests.

 * [834f73f](../../commit/834f73f) - __(Joshua Hoblitt)__ add class smartd $service_ensure param
 * [6475a9e](../../commit/6475a9e) - __(Joshua Hoblitt)__ merge class smartd $ensure and $autoupdate params
 * [4c6b9bc](../../commit/4c6b9bc) - __(Joshua Hoblitt)__ Merge remote-tracking branch 'skel/master'
 * [ed6a68b](../../commit/ed6a68b) - __(Joshua Hoblitt)__ ignore patch related files *{.orig,.rej,.patch}
 * [6a67990](../../commit/6a67990) - __(Joshua Hoblitt)__ add puppet-syntax support
 * [dddb48a](../../commit/dddb48a) - __(Michael Arnold)__ Clean up resource dependencies.
 * [d78077b](../../commit/d78077b) - __(Michael Arnold)__ Use puppetlabs/stdlib to validate inputs.
 * [fb78b8b](../../commit/fb78b8b) - __(Michael Arnold)__ Updated rspec tests to deal with fix to template.

Added shell_config to .fixtures.yml.
Added a whole lot of testing of various parameters and template
configurations on all supported osfamilies.

 * [435661d](../../commit/435661d) - __(Joshua Hoblitt)__ add travis-ci build placard
 * [fb932f9](../../commit/fb932f9) - __(Joshua Hoblitt)__ add example spec test
 * [4050f0d](../../commit/4050f0d) - __(Joshua Hoblitt)__ add a default .travis.yml
 * [3b28801](../../commit/3b28801) - __(Joshua Hoblitt)__ exclude travis-ci testing of puppet < 3.2 with ruby >= 2.0
 * [be9867d](../../commit/be9867d) - __(Joshua Hoblitt)__ fix travis-ci placard url
 * [c1141d8](../../commit/c1141d8) - __(Joshua Hoblitt)__ add travis-ci testing with ruby 2.0.0 and puppet 3.2.1
 * [4732693](../../commit/4732693) - __(Joshua Hoblitt)__ pull gems from https://rubygems instead of :rubygems
 * [d16cc78](../../commit/d16cc78) - __(Joshua Hoblitt)__ git ignore Gemfile.lock
 * [9b35dd8](../../commit/9b35dd8) - __(Michael Arnold)__ Updated rspec tests to deal with fix to template.

Added shell_config to .fixtures.yml.
Added a whole lot of testing of various parameters and template
configurations on all supported osfamilies.

 * [c46ff1e](../../commit/c46ff1e) - __(Joshua Hoblitt)__ git ignore Gemfile.lock
 * [e86f789](../../commit/e86f789) - __(Joshua Hoblitt)__ install ruby gems from https://rubygems.org instead of :rubygems

To resolve this warning:

    The source :rubygems is deprecated because HTTP requests are insecure.
    Please change your source to 'https://rubygems.org' if possible, or
    'http://rubygems.org' if not.

 * [ecd8877](../../commit/ecd8877) - __(Michael Arnold)__ Make puppetdoc work.
 * [cedc03d](../../commit/cedc03d) - __(Michael Arnold)__ Format output to have spaces and linefeeds in the right places.
 * [d4ab6d6](../../commit/d4ab6d6) - __(Joshua Hoblitt)__ fix setting megaraid device options via device_opts => { 'megaraid' => ... }
 * [d487c9a](../../commit/d487c9a) - __(Joshua Hoblitt)__ add travis-ci status to README.md
 * [8f82a65](../../commit/8f82a65) - __(Joshua Hoblitt)__ overhaul smartd.conf template

improve readability
sort megaraid device & disks
fix some whitespace issues

 * [bb34e2d](../../commit/bb34e2d) - __(Joshua Hoblitt)__ add a couples of spec tests to cover basic usage
 * [56c987b](../../commit/56c987b) - __(Joshua Hoblitt)__ Merge pull request [#1](../../issues/1) from ucam-cl-dtg/master

Test for megaraid device symbols being :undefined in smartd.conf template
 * [9982990](../../commit/9982990) - __(Joshua Hoblitt)__ rename README -> README.md, tweak README, mv all API docs to smartd.pp
 * [096eb58](../../commit/096eb58) - __(Joshua Hoblitt)__ rename smartd::defaults -> smartd::params

To better adhere to the current defacto naming conventions.

 * [65fdc06](../../commit/65fdc06) - __(Joshua Hoblitt)__ fix all lint issues and add per class docs
 * [3463290](../../commit/3463290) - __(Andrew Rice)__ Added a test to see if the lookup variables megaraid_device and megaraid_drive are :undefined

When running without megaraid devices puppet throws an error about being unable
to split on :undefined:Symbol so we should test if its undefined and not attempt
the split

 * [9260f66](../../commit/9260f66) - __(Joshua Hoblitt)__ add spec/lint/travis boilerplate
 * [e02f06c](../../commit/e02f06c) - __(Joshua Hoblitt)__ restart smartd service when smartd.conf is modified
 * [8387586](../../commit/8387586) - __(Joshua Hoblitt)__ mv DEVICESCAN to the end of smartd.conf

once DEVICESCAN has probed a block device smartd will ignore any subsequent
commands in the smartd.conf file for that block device

 * [93d1ef5](../../commit/93d1ef5) - __(Joshua Hoblitt)__ fix SAT warning on Linux (unknown if this breaks SAS disks) fix template .to_i error from trying to convert an array into an integer

This is the SAT error:

/dev/sdc [megaraid_disk_14] [SAT]: Device open changed type from 'megaraid' to 'sat'
Smartctl open device: /dev/sdc [megaraid_disk_14] [SAT] failed: SATA device detected,
MegaRAID SAT layer is reportedly buggy, use '-d sat+megaraid,N' to try anyhow

 * [f2042c3](../../commit/f2042c3) - __(Joshua Hoblitt)__ rename megaraid_smartd_device_name fact to megaraid_virtual_drives and list all megaraid VD block devices
 * [5a1fd71](../../commit/5a1fd71) - __(Joshua Hoblitt)__ change the megaraid_physical_drives fact to probe with lsscsi

The existing smartctl based probe fails on rhel6.x with these package versions:

smartmontools-5.42-2.el6.x86_64
kernel-2.6.32-279.9.1.el6.x86_64

It's unknown if the smartctl probe works with other el6.x tool + kernel
combinations.  It's hoped that the lsscsi based probe will be more robost
(unless the output format of lsscsi changes).

 * [73827bb](../../commit/73827bb) - __(Joshua Hoblitt)__ sort the megaraid_physical_drives fact's drive listing
 * [58887e2](../../commit/58887e2) - __(Joshua Hoblitt)__ rename class smartd param $scan -> $devicescan

it's slightly better 'self documenting' if the class params match the configuration file directives

 * [0b3f1b9](../../commit/0b3f1b9) - __(Joshua Hoblitt)__ rename class smartd param $schedule -> $warning_schedule to silence warning

Warning: schedule is a metaparam; this value will inherit to all contained resources in the smartd definition

 * [89c55ce](../../commit/89c55ce) - __(Joshua Hoblitt)__ add param $devicescan_options to class smartd

used to pass arguments to the DEVICESCAN directive in smartd configuration file

 * [51b6a10](../../commit/51b6a10) - __(Joshua Hoblitt)__ add param $enable_monit to class smartd

Used to enable/disable automatic declaration of a monit::monitor resource.  Default is false.

 * [f8b56a9](../../commit/f8b56a9) - __(Joshua Hoblitt)__ add $::osfamily == 'RedHat' support
 * [95df6b6](../../commit/95df6b6) - __(Joshua Hoblitt)__ first commit
 * [40b923e](../../commit/40b923e) - __(Garrett Wollman)__ Add metadata so we can submit this module to the Forge
 * [c3aee00](../../commit/c3aee00) - __(Garrett Wollman)__ Initial revision
