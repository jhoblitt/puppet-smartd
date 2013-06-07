require 'spec_helper'

describe 'smartd' do
  let(:title) { 'redhat' }
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
