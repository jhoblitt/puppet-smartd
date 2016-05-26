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

    group = nil
    if values && values[:group]
      group = values[:group]
    else
      group = 'root'
    end

    it { should contain_package('smartmontools').with_ensure('present') }
    it do
      should contain_file(config_file).with({
        :ensure  => 'present',
        :owner   => 'root',
        :group   => group,
        :mode    => '0644',
      })
    end
    it "should contain File[#{config_file}] with correct contents" do
      verify_contents(catalogue, config_file, content)
    end
  end

  describe 'on a supported osfamily, default parameters' do
    describe 'for osfamily SuSE' do
      let(:facts) {{ :osfamily => 'SuSE', :smartmontools_version => '5.43', :gid => 'root' }}

      it_behaves_like 'default', {}
      it { should_not contain_augeas('shell_config_start_smartd') }
      it { should contain_service('smartd').with_ensure('running').with_enable(true) }
      it { should contain_file('/etc/smartd.conf').with_notify('Service[smartd]') }
    end

    describe 'for osfamily RedHat' do
      describe 'for operatingsystem RedHat' do
        describe 'for operatingsystemmajrelease 6' do
          let(:facts) {{ :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemmajrelease => '6', :smartmontools_version => '5.43', :gid => 'root' }}

          it_behaves_like 'default', {}
          it { should_not contain_augeas('shell_config_start_smartd') }
          it { should contain_service('smartd').with_ensure('running').with_enable(true) }
          it { should contain_service('smartd').with_subscribe('File[/etc/smartd.conf]') }
        end

        describe 'for operatingsystemmajrelease 7' do
          let(:facts) {{ :osfamily => 'RedHat', :operatingsystem => 'RedHat', :operatingsystemmajrelease => '7', :smartmontools_version => '6.2', :gid => 'root' }}

          it_behaves_like 'default', { :config_file => '/etc/smartmontools/smartd.conf' }
          it { should_not contain_augeas('shell_config_start_smartd') }
          it { should contain_service('smartd').with_ensure('running').with_enable(true) }
          it { should contain_service('smartd').with_subscribe('File[/etc/smartmontools/smartd.conf]') }
        end
      end

      describe 'for operatingsystem Fedora' do
        describe 'for operatingsystemrelease 18' do
          let(:facts) {{ :osfamily => 'RedHat', :operatingsystem => 'Fedora', :operatingsystemrelease => '18', :smartmontools_version => '5.43', :gid => 'root' }}

          it_behaves_like 'default', {}
          it { should_not contain_augeas('shell_config_start_smartd') }
          it { should contain_service('smartd').with_ensure('running').with_enable(true) }
          it { should contain_service('smartd').with_subscribe('File[/etc/smartd.conf]') }
        end

        describe 'for operatingsystemrelease 19' do
          let(:facts) {{ :osfamily => 'RedHat', :operatingsystem => 'Fedora', :operatingsystemrelease => '19', :smartmontools_version => '6.1', :gid => 'root' }}

          it_behaves_like 'default', { :config_file => '/etc/smartmontools/smartd.conf' }
          it { should_not contain_augeas('shell_config_start_smartd') }
          it { should contain_service('smartd').with_ensure('running').with_enable(true) }
          it { should contain_service('smartd').with_subscribe('File[/etc/smartmontools/smartd.conf]') }
        end
      end
    end

    describe 'for osfamily Debian' do
      let(:facts) {{ :osfamily => 'Debian', :smartmontools_version => '5.43', :gid => 'root' }}

      it_behaves_like 'default', {}
      it { should contain_augeas('shell_config_start_smartd').with_changes('set start_smartd "yes"') }
      it { should contain_service('smartmontools').with_ensure('running').with_enable(true) }
      it { should contain_service('smartmontools').with_subscribe('File[/etc/smartd.conf]') }
    end

    describe 'for osfamily FreeBSD' do
      let(:facts) {{ :osfamily => 'FreeBSD', :smartmontools_version => '5.43', :gid => 'wheel' }}

      it_behaves_like 'default', { :config_file => '/usr/local/etc/smartd.conf', :group => 'wheel' }
      it { should_not contain_augeas('shell_config_start_smartd') }
      it { should contain_service('smartd').with_ensure('running').with_enable(true) }
      it { should contain_service('smartd').with_subscribe('File[/usr/local/etc/smartd.conf]') }
    end

  end

  describe 'on a supported osfamily, custom parameters' do
    describe 'for osfamily RedHat' do
      let(:facts) {{ :osfamily => 'RedHat', :smartmontools_version => '5.43' }}

      describe 'ensure => present' do
        let(:params) {{ :ensure => 'present' }}

        it { should contain_package('smartmontools').with_ensure('present') }
        it { should contain_service('smartd').with_ensure('running').with_enable(true) }
        it { should contain_service('smartd').with_subscribe('File[/etc/smartd.conf]') }
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
        it { should_not contain_service('smartd') }
        it { should contain_file('/etc/smartd.conf').with_ensure('absent') }
      end

      describe 'ensure => purge' do
        let(:params) {{ :ensure => 'purged' }}

        it { should contain_package('smartmontools').with_ensure('purged') }
        it { should_not contain_service('smartd') }
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

      describe 'manage_service => false' do
        let(:params) {{ :manage_service => false }}

        it { should_not contain_service('smartd') }
      end

      describe 'service_ensure => badvalue' do
        let(:params) {{ :service_ensure => 'badvalue' }}

        it 'should fail' do
          expect {
            should raise_error(Puppet::Error, /unsupported value of/)
          }
        end
      end

      describe 'devicescan =>' do
        context '(default)' do
          it do
            should contain_file('/etc/smartd.conf').
              with_ensure('present').
              with_content(/^DEVICESCAN$/)
          end
        end # (default)

        context 'true' do
          let(:params) {{ :devicescan => true }}

          it do
            should contain_file('/etc/smartd.conf').
              with_ensure('present').
              with_content(/^DEVICESCAN$/)
          end

          context 'enable_default => false' do
            before { params[:enable_default] = false }

            it 'should have the same arguments as DEFAULT would have' do
              should contain_file('/etc/smartd.conf').
                with_ensure('present').
                with_content(/^DEVICESCAN -m root -M daily$/)
            end
          end
        end # true

        context 'false' do
          let(:params) {{ :devicescan => false }}

          it do
            should contain_file('/etc/smartd.conf').
              with_ensure('present').
              without_content(/^DEVICESCAN$/)
          end
        end # false

        context 'foo' do
          let(:params) {{ :devicescan => 'foo' }}
          it 'should fail' do
            expect {
              should raise_error(Puppet::Error, /is not a boolean../)
            }
          end
        end
      end # devicescan =>

      describe 'devicescan_options => somevalue' do
        let(:params) {{ :devicescan_options => 'somevalue' }}

        it { should contain_file('/etc/smartd.conf').with_ensure('present') }
        it 'should contain file /etc/smartd.conf with contents ...' do
          verify_contents(catalogue, '/etc/smartd.conf', [
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
          verify_contents(catalogue, '/etc/smartd.conf', [
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
          verify_contents(catalogue, '/etc/smartd.conf', [
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
          verify_contents(catalogue, '/etc/smartd.conf', [
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
          verify_contents(catalogue, '/etc/smartd.conf', [
            'DEFAULT -m someguy@localdomain -M daily',
          ])
        end
      end

      describe 'warning_schedule => diminishing' do
        let(:params) {{ :warning_schedule => 'diminishing' }}

        it { should contain_file('/etc/smartd.conf').with_ensure('present') }
        it 'should contain file /etc/smartd.conf with contents ...' do
          verify_contents(catalogue, '/etc/smartd.conf', [
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

      describe 'enable_default => ' do
        context '(default)' do
          context 'fact smartmontool_version = "5.43"' do
            before { facts[:smartmontools_version] = '5.43' }
            it do
              should contain_file('/etc/smartd.conf').with_ensure('present').
                with_content(/DEFAULT -m root -M daily/)
            end
          end

          context 'fact smartmontool_version = "5.42"' do
            before { facts[:smartmontools_version] = '5.42' }
            it do
              should contain_file('/etc/smartd.conf').with_ensure('present').
                without_content(/DEFAULT -m root -M daily/).
                with_content(/DEVICESCAN -m root -M daily/)
            end
          end
        end # (default)

        context 'true' do
          let(:params) {{ :enable_default => true }}
          it do
            should contain_file('/etc/smartd.conf').with_ensure('present').
              with_content(/DEFAULT -m root -M daily/)
          end
        end

        context 'false' do
          let(:params) {{ :enable_default => false }}
          it do
            should contain_file('/etc/smartd.conf').with_ensure('present').
              without_content(/DEFAULT -m root -M daily/).
              with_content(/DEVICESCAN -m root -M daily/)
          end
        end

        context 'foo' do
          let(:params) {{ :enable_default => 'foo' }}
          it 'should fail' do
            expect {
              should raise_error(Puppet::Error, /is not a boolean../)
            }
          end
        end
      end # enable_default =>

      describe 'default_options => ' do
        context '(default)' do
          let(:params) {{ }}

          context 'default => true' do
            before { params[:enable_default] = true }

            it do
              should contain_file('/etc/smartd.conf').with_ensure('present').
                with_content(/DEFAULT -m root -M daily/)
            end
          end

          context 'enable_default => false' do
            before { params[:enable_default] = false }

            it do
              should contain_file('/etc/smartd.conf').with_ensure('present').
                without_content(/DEFAULT -m root -M daily/).
                with_content(/DEVICESCAN -m root -M daily/)
            end
          end
        end # (default)

        context 'undef' do
          let(:params) {{ :default_options => nil }}

          context 'enable_default => true' do
            before { params[:enable_default] = true }

            it do
              should contain_file('/etc/smartd.conf').with_ensure('present').
                with_content(/DEFAULT -m root -M daily/)
            end
          end

          context 'enable_default => false' do
            before { params[:enable_default] = false }

            it do
              should contain_file('/etc/smartd.conf').with_ensure('present').
                without_content(/DEFAULT -m root -M daily/).
                with_content(/DEVICESCAN -m root -M daily/)
            end
          end
        end # undef

        context '-H' do
          let(:params) {{ :default_options => '-H'}}

          context 'enable_default => true' do
            before { params[:enable_default] = true }

            it do
              should contain_file('/etc/smartd.conf').with_ensure('present').
                with_content(/DEFAULT -m root -M daily -H/)
            end
          end

          context 'enable_default => false' do
            before { params[:enable_default] = false }

            it do
              should contain_file('/etc/smartd.conf').with_ensure('present').
                without_content(/DEFAULT -m root -M daily -H/).
                with_content(/DEVICESCAN -m root -M daily -H/)
            end
          end
        end # -H

        context '[]' do
          let(:params) {{ :default_options => [] }}
          it 'should fail' do
            expect {
              should raise_error(Puppet::Error, /is not an Array../)
            }
          end
        end # []
      end # default_options =>
    end

    describe 'for osfamily Debian' do
      let(:facts) {{ :osfamily => 'Debian', :smartmontools_version => '5.43' }}

      describe 'ensure => present' do
        let(:params) {{ :ensure => 'present' }}

        it { should contain_augeas('shell_config_start_smartd').with_changes('set start_smartd "yes"') }
      end

      describe 'ensure => latest' do
        let(:params) {{ :ensure => 'latest' }}

        it { should contain_augeas('shell_config_start_smartd').with_changes('set start_smartd "yes"') }
      end

      describe 'ensure => absent' do
        let(:params) {{ :ensure => 'absent' }}

        it { should contain_augeas('shell_config_start_smartd').with_changes('remove start_smartd') }
      end

      describe 'ensure => purged' do
        let(:params) {{ :ensure => 'purged' }}

        it { should contain_augeas('shell_config_start_smartd').with_changes('remove start_smartd') }
      end

      describe 'ensure => absent and service_ensure => running' do
        let(:params) {{ :ensure => 'absent',  :service_ensure => 'running' }}

        it { should contain_augeas('shell_config_start_smartd').with_changes('remove start_smartd') }
      end

      describe 'ensure => purged and service_ensure => running' do
        let(:params) {{ :ensure => 'purged',  :service_ensure => 'running' }}

        it { should contain_augeas('shell_config_start_smartd').with_changes('remove start_smartd') }
      end

      describe 'service_ensure => running' do
        let(:params) {{ :service_ensure => 'running' }}

        it { should contain_augeas('shell_config_start_smartd').with_changes('set start_smartd "yes"') }
      end

      describe 'service_ensure => stopped' do
        let(:params) {{ :service_ensure => 'stopped' }}

        it { should contain_augeas('shell_config_start_smartd').with_changes('remove start_smartd') }
      end
    end
  end


  describe 'megaraid support' do

    describe 'without params + megaraid sata facts' do
      let(:facts) do
        {
          :osfamily                      => 'RedHat',
          :megaraid_adapters             => '1',
          :megaraid_virtual_drives       => 'sdb,sda',
          :megaraid_physical_drives_sata => '2,1',
          :smartmontools_version         => '5.43',
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

    describe 'without params + megaraid sas facts' do
      let(:facts) do
        {
          :osfamily                      => 'RedHat',
          :megaraid_adapters             => '1',
          :megaraid_virtual_drives       => 'sdb,sda',
          :megaraid_physical_drives_sas  => '2,1',
          :smartmontools_version         => '5.43',
        }
      end

      it do
        should contain_file('/etc/smartd.conf')\
          .with_content(<<-END.gsub(/^\s+/, ""))
            # Managed by Puppet -- do not edit!
            DEFAULT -m root -M daily
            /dev/sda -d megaraid,1
            /dev/sda -d megaraid,2
            DEVICESCAN
          END
      end
    end

    describe 'without params + megaraid sata+sas facts' do
      let(:facts) do
        {
          :osfamily                      => 'RedHat',
          :megaraid_adapters             => '1',
          :megaraid_virtual_drives       => 'sdb,sda',
          :megaraid_physical_drives_sas  => '1,2',
          :megaraid_physical_drives_sata => '3,4',
          :smartmontools_version         => '5.43',
        }
      end

      it do
        should contain_file('/etc/smartd.conf')\
          .with_content(<<-END.gsub(/^\s+/, ""))
            # Managed by Puppet -- do not edit!
            DEFAULT -m root -M daily
            /dev/sda -d sat+megaraid,3
            /dev/sda -d sat+megaraid,4
            /dev/sda -d megaraid,1
            /dev/sda -d megaraid,2
            DEVICESCAN
          END
      end
    end

    describe 'with params + megaraid facts' do
      let(:facts) do
        {
          :osfamily                      => 'RedHat',
          :megaraid_adapters             => '1',
          :megaraid_virtual_drives       => 'sdb,sda',
          :megaraid_physical_drives_sata => '2,1',
          :smartmontools_version         => '5.43',
        }
      end
      let(:params) do
        {
          :devices => [{ 'device' => 'megaraid', 'options' => '-I 194' }],
        }
      end

      it do
        should contain_class('smartd')
        should contain_class('smartd::params')
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
