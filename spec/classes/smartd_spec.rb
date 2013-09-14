require 'spec_helper'

describe 'smartd', :type => :class do

  context 'on a non-supported osfamily' do
    let :facts do
      {
        :osfamily        => 'foo',
        :operatingsystem => 'bar'
      }
    end

    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /smartd: unsupported OS family bar/)
      }
    end
  end

  context 'on a supported osfamily, default parameters' do
    describe 'for osfamily RedHat' do
      let(:facts) {{ :osfamily => 'RedHat' }}

      it { should contain_package('smartmontools').with_ensure('present') }
      it { should contain_service('smartd').with(
        :ensure     => 'running',
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
      )}
      it { should contain_file('/etc/smartd.conf').with(
        :ensure  => 'present',
        :owner   => 'root',
        :group   => '0',
        :mode    => '0644',
        :notify  => 'Service[smartd]'
      )}
      it 'should contain File[/etc/smartd.conf] with correct contents' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          'DEVICESCAN',
        ])
      end
      it { should_not contain_shell_config('start_smartd') }
    end

    describe 'for osfamily Debian' do
      let(:facts) {{ :osfamily => 'Debian' }}

      it { should contain_package('smartmontools').with_ensure('present') }
      it { should contain_service('smartd').with(
        :ensure     => 'running',
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
      )}
      it { should contain_file('/etc/smartd.conf').with(
        :ensure  => 'present',
        :owner   => 'root',
        :group   => '0',
        :mode    => '0644',
        :require => 'Package[smartmontools]',
        :notify  => 'Service[smartd]'
      )}
      it 'should contain File[/etc/smartd.conf] with correct contents' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          'DEVICESCAN',
        ])
      end
      it { should contain_shell_config('start_smartd').with(
        :ensure  => 'present',
        :file    => '/etc/default/smartmontools',
        :key     => 'start_smartd',
        :value   => 'yes',
        :before  => 'Service[smartd]'
      )}
    end

    describe 'for osfamily FreeBSD' do
      let(:facts) {{ :osfamily => 'FreeBSD' }}

      it { should contain_package('smartmontools').with_ensure('present') }
      it { should contain_service('smartd').with(
        :ensure     => 'running',
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
      )}
      it { should contain_file('/usr/local/etc/smartd.conf').with(
        :ensure  => 'present',
        :owner   => 'root',
        :group   => '0',
        :mode    => '0644',
        :require => 'Package[smartmontools]',
        :notify  => 'Service[smartd]'
      )}
      it 'should contain File[/usr/local/etc/smartd.conf] with correct contents' do
        verify_contents(subject, '/usr/local/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          'DEVICESCAN',
        ])
      end
      it { should_not contain_shell_config('start_smartd') }
    end

  end

  context 'on a supported osfamily, custom parameters' do
    let(:facts) {{ :osfamily => 'RedHat' }}

    describe 'ensure => present' do
      let(:params) {{ :ensure => 'present' }}

      it { should contain_package('smartmontools').with_ensure('present') }
      it { should contain_service('smartd').with_ensure('running').with_enable(true) }
      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
    end

    describe 'ensure => latest' do
      let(:params) {{ :ensure => 'latest' }}

      it { should contain_package('smartmontools').with_ensure('latest') }
      it { should contain_service('smartd').with_ensure('running').with_enable(true) }
      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
    end

    describe 'ensure => absent' do
      let(:params) {{ :ensure => 'absent' }}

      it { should contain_package('smartmontools').with_ensure('absent') }
      it { should contain_service('smartd').with_ensure('stopped').with_enable(false) }
      it { should contain_file('/etc/smartd.conf').with_ensure('absent') }
    end

    describe 'ensure => purge' do
      let(:params) {{ :ensure => 'purged' }}

      it { should contain_package('smartmontools').with_ensure('purged') }
      it { should contain_service('smartd').with_ensure('stopped').with_enable(false) }
      it { should contain_file('/etc/smartd.conf').with_ensure('absent') }
    end

    describe 'ensure => badvalue' do
      let(:params) {{ :ensure => 'badvalue' }}

      it 'should fail' do
        expect {
          should raise_error(Puppet::Error, /unsupported value of $ensure: badvalue/)
        }
      end
    end

    describe 'devicescan => false' do
      let(:params) {{ :devicescan => false }}

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it { should_not contain_file('/etc/smartd.conf').with_content(/^DEVICESCAN$/) }
    end

    describe 'devicescan_options => somevalue' do
      let(:params) {{ :devicescan_options => 'somevalue' }}

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain File[/etc/smartd.conf] with contents "DEVICESCAN somevalue"' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          'DEVICESCAN somevalue',
        ])
      end
    end

    describe 'devices => [ /dev/sg1, /dev/sg2 ]' do
      let(:params) {{ :devices => [ '/dev/sg1', '/dev/sg2', ] }}

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain File[/etc/smartd.conf] with contents "/dev/sg1\n/dev/sg2"' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          '/dev/sg1',
          '/dev/sg2',
        ])
      end
    end

    describe 'device_opts => "{ /dev/sg1 => -o on -S on -a, /dev/sg2 => -o on -S on -a }"' do
      let :params do {
        :devices     => [ '/dev/sg1', '/dev/sg2', ],
        :device_opts => { '/dev/sg1' => '-o on -S on -a', '/dev/sg2' => '-o on -S on -a' }
      }
      end

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain File[/etc/smartd.conf] with contents "/dev/sg1 -o on -S on -a\n/dev/sg2 -o on -S on -a"' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          '/dev/sg1 -o on -S on -a',
          '/dev/sg2 -o on -S on -a',
        ])
      end
    end

    describe 'mail_to => someguy@localdomain' do
      let(:params) {{ :mail_to => 'someguy@localdomain' }}

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain File[/etc/smartd.conf] with contents "DEFAULT -m someguy@localdomain -M daily"' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m someguy@localdomain -M daily',
        ])
      end
    end

    describe 'warning_schedule => diminishing' do
      let(:params) {{ :warning_schedule => 'diminishing' }}

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain File[/etc/smartd.conf] with contents "DEFAULT -m root -M diminishing"' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M diminishing',
        ])
      end
    end

    describe 'warning_schedule => badvalue' do
      let(:params) {{ :warning_schedule => 'badvalue' }}

      it 'should fail' do
        expect {
          should raise_error(Puppet::Error, /$warning_schedule must be either daily, once, or diminishing./)
        }
      end
    end

  end


  let(:facts) { {:osfamily=> 'RedHat', :lsbmajordistrelease => 6} }

  context 'without params' do
    it do
      should include_class('smartd')
      should include_class('smartd::params')
      should contain_package('smartmontools')
      should contain_service('smartd')
      should contain_file('/etc/smartd.conf')\
        .with_content(<<-END.gsub(/^\s+/, ""))
          # Managed by Puppet -- do not edit!
          DEFAULT -m root -M daily
          DEVICESCAN
        END
    end
  end

  context 'without params + megaraid facts' do
    let(:facts) do
      {
        :osfamily=> 'RedHat', :lsbmajordistrelease => 6,
        :megaraid_adapters        => '1',
        :megaraid_virtual_drives  => '/dev/sdb,/dev/sda',
        :megaraid_physical_drives => '2,1',
      }
    end

    it do
      should include_class('smartd')
      should include_class('smartd::params')
      should contain_package('smartmontools')
      should contain_service('smartd')
      should contain_file('/etc/smartd.conf')\
        .with_content(<<-END.gsub(/^\s+/, ""))
          # Managed by Puppet -- do not edit!
          DEFAULT -m root -M daily
          /dev/sda -d sat+megaraid,1
          /dev/sda -d sat+megaraid,2
          DEVICESCAN
        END
    end
  end

  context 'without params + megaraid facts' do
    let(:facts) do
      {
        :osfamily=> 'RedHat', :lsbmajordistrelease => 6,
        :megaraid_adapters        => '1',
        :megaraid_virtual_drives  => '/dev/sdb,/dev/sda',
        :megaraid_physical_drives => '2,1',
      }
    end

    let(:params) do
      {
        :device_opts => { 'megaraid' => '-I 194'},
      }
    end

    it do
      should include_class('smartd')
      should include_class('smartd::params')
      should contain_package('smartmontools')
      should contain_service('smartd')
      should contain_file('/etc/smartd.conf')\
        .with_content(<<-END.gsub(/^\s+/, ""))
          # Managed by Puppet -- do not edit!
          DEFAULT -m root -M daily
          /dev/sda -d sat+megaraid,1 -I 194
          /dev/sda -d sat+megaraid,2 -I 194
          DEVICESCAN
        END
    end
  end
end
