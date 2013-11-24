require 'spec_helper'

describe 'smartd', :type => :class do

  shared_examples_for 'default' do |values|
    content = nil
    if values && values[:content]
      content = values[:content]
    else
      content = [
        'DEFAULT -m root -M daily',
        'DEVICESCAN',
      ]
    end

    config_file = nil
    if values && values[:config_file]
      config_file = values[:config_file]
    else
      config_file = '/etc/smartd.conf'
    end

    it { should contain_package('smartmontools').with_ensure('present') }
    it do
      should contain_service('smartd').with({
        :ensure     => 'running',
        :enable     => true,
        :hasstatus  => true,
        :hasrestart => true,
      })
    end
    it do
      should contain_file(config_file).with({
        :ensure  => 'present',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0644',
        :notify  => 'Service[smartd]'
      })
    end
    it "should contain File[#{config_file}] with correct contents" do
      verify_contents(subject, config_file, content)
    end
  end

  describe 'on a supported osfamily, default parameters' do
    describe 'for osfamily RedHat' do
      let(:facts) {{ :osfamily => 'RedHat' }}

      it_behaves_like 'default', {}
      it { should_not contain_shell_config('start_smartd') }
    end

    describe 'for osfamily Debian' do
      let(:facts) {{ :osfamily => 'Debian' }}

      it_behaves_like 'default', {}
      it { should contain_shell_config('start_smartd') }
    end

    describe 'for osfamily FreeBSD' do
      let(:facts) {{ :osfamily => 'FreeBSD' }}

      it_behaves_like 'default', { :config_file => '/usr/local/etc/smartd.conf' }
      it { should_not contain_shell_config('start_smartd') }
    end

  end

  describe 'on a supported osfamily, custom parameters' do
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

    describe 'service_ensure => running' do
      let(:params) {{ :service_ensure => 'running' }}

      it { should contain_package('smartmontools').with_ensure('present') }
      it { should contain_service('smartd').with_ensure('running').with_enable(true) }
    end

    describe 'service_ensure => stopped' do
      let(:params) {{ :service_ensure => 'stopped' }}

      it { should contain_package('smartmontools').with_ensure('present') }
      it { should contain_service('smartd').with_ensure('stopped').with_enable(false) }
    end

    describe 'service_ensure => badvalue' do
      let(:params) {{ :service_ensure => 'badvalue' }}

      it 'should fail' do
        expect {
          should raise_error(Puppet::Error, /unsupported value of/)
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
      it 'should contain file /etc/smartd.conf with contents ...' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          'DEVICESCAN somevalue',
        ])
      end
    end

    describe 'devices without options' do
      let(:params) do
        {
          'devices' => [
            { 'device' => '/dev/sg1' },
            { 'device' => '/dev/sg2' },
          ],
        }
      end

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain file /etc/smartd.conf with contents ...' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          '/dev/sg1',
          '/dev/sg2',
        ])
      end
    end

    describe 'devices with options"' do
      let :params do
        {
          'devices' => [
            { 'device' => '/dev/sg1', 'options' => '-o on -S on -a' },
            { 'device' => '/dev/sg2', 'options' => '-o on -S on -a' },
          ],
        }
      end

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain file /etc/smartd.conf with contents ...' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          '/dev/sg1 -o on -S on -a',
          '/dev/sg2 -o on -S on -a',
        ])
      end
    end

    describe 'devices with options"' do
      let :params do
        {
          'devices' => [
            { 'device' => '/dev/cciss/c0d0', 'options' => '-d cciss,0 -a -o on -S on' },
            { 'device' => '/dev/cciss/c0d0', 'options' => '-d cciss,1 -a -o on -S on' },
            { 'device' => '/dev/cciss/c0d0', 'options' => '-d cciss,2 -a -o on -S on' },
            { 'device' => '/dev/cciss/c0d0', 'options' => '-d cciss,3 -a -o on -S on' },
            { 'device' => '/dev/cciss/c0d0', 'options' => '-d cciss,4 -a -o on -S on' },
            { 'device' => '/dev/cciss/c0d0', 'options' => '-d cciss,5 -a -o on -S on' },

          ],
        }
      end

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain file /etc/smartd.conf with contents ...' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m root -M daily',
          '/dev/cciss/c0d0 -d cciss,0 -a -o on -S on',
          '/dev/cciss/c0d0 -d cciss,1 -a -o on -S on',
          '/dev/cciss/c0d0 -d cciss,2 -a -o on -S on',
          '/dev/cciss/c0d0 -d cciss,3 -a -o on -S on',
          '/dev/cciss/c0d0 -d cciss,4 -a -o on -S on',
          '/dev/cciss/c0d0 -d cciss,5 -a -o on -S on',
        ])
      end
    end

    describe 'mail_to => someguy@localdomain' do
      let(:params) {{ :mail_to => 'someguy@localdomain' }}

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain file /etc/smartd.conf with contents ...' do
        verify_contents(subject, '/etc/smartd.conf', [
          'DEFAULT -m someguy@localdomain -M daily',
        ])
      end
    end

    describe 'warning_schedule => diminishing' do
      let(:params) {{ :warning_schedule => 'diminishing' }}

      it { should contain_file('/etc/smartd.conf').with_ensure('present') }
      it 'should contain file /etc/smartd.conf with contents ...' do
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


  describe 'megaraid support' do

    describe 'without params + megaraid facts' do
      let(:facts) do
        {
          :osfamily=> 'RedHat',
          :megaraid_adapters        => '1',
          :megaraid_virtual_drives  => 'sdb,sda',
          :megaraid_physical_drives => '2,1',
        }
      end

      it do
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

    describe 'without params + megaraid facts' do
      let(:facts) do
        {
          :osfamily=> 'RedHat',
          :megaraid_adapters        => '1',
          :megaraid_virtual_drives  => 'sdb,sda',
          :megaraid_physical_drives => '2,1',
        }
      end
      let(:params) do
        {
          :devices => [{ 'device' => 'megaraid', 'options' => '-I 194' }],
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
end
