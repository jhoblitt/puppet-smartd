require 'spec_helper_system'

describe 'smartd class' do
  package_name = 'smartmontools'
  case node.facts['osfamily']
  when 'RedHat'
    service_name = 'smartd'
  when 'Debian'
    service_name = 'smartmontools'
  end

  describe 'running puppet code' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'smartd': }
      EOS

      # Run it twice and test for idempotency
      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should be_zero
      end
    end
  end

  describe package(package_name) do
    it { should be_installed }
  end

  describe service(service_name) do
    it { should be_running }
    it { should be_enabled }
  end

  describe file('/etc/smartd.conf') do
    it { should be_file }
    it { should contain([
      'DEFAULT -m root -M daily',
      'DEVICESCAN',
    ]) }
  end
end
