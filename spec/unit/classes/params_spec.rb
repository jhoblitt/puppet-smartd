require 'spec_helper'

describe 'smartd::params', :type => :class do
  shared_examples 'osfamily' do |family|
    let(:facts) { { :osfamily => family } }

    it { is_expected.to contain_class('smartd::params') }
  end

  describe 'for osfamily RedHat' do
    it_behaves_like 'osfamily', 'RedHat'
  end

  describe 'for osfamily Debian' do
    it_behaves_like 'osfamily', 'Debian'
  end

  describe 'for osfamily FreeBSD' do
    it_behaves_like 'osfamily', 'FreeBSD'
  end

  describe 'unsupported osfamily' do
    let :facts do
      {
        :osfamily        => 'Solaris',
        :operatingsystem => 'Solaris',
      }
    end

    it 'should fail' do
      expect { is_expected.to contain_class('smartd::params') }.
        to raise_error(Puppet::Error, /not supported on Solaris/)
    end
  end
end
