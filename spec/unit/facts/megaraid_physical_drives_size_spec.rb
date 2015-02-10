require 'spec_helper'

describe 'megaraid_physical_drives_size', :type => :fact do
  before(:each) { Facter.clear }

  describe 'on linux' do
    context 'megacli not in path' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns(nil)

        Facter.fact(:megaraid_physical_drives_size).value.should be_nil
      end
    end

    context 'megacli is broken' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns(nil)

        Facter.fact(:megaraid_physical_drives_size).value.should be_nil
      end

      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('1')
        Facter::Util::Resolution.stubs(:exec).with('/usr/bin/MegaCli -PDList -aALL -NoLog').
          returns(nil)

        Facter.fact(:megaraid_physical_drives_size).value.should be_nil
      end
    end

    context 'no adapters' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('0')

        Facter.fact(:megaraid_physical_drives_size).value.should be_nil
      end
    end

    context '1 adapter' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('1')
        Facter::Util::Resolution.stubs(:exec).with('/usr/bin/MegaCli -PDList -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'pdlistaall')))

        sizes = '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,' +
                '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,' +
                '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,' +
                '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,' +
                '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,' +
                '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,' +
                '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,186.310 GB,' +
                '186.310 GB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,' +
                '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,' +
                '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,' +
                '3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB,3.638 TB'
        Facter.fact(:megaraid_physical_drives_size).value.should == sizes
      end
    end
  end # on linux

  context 'not on linux' do
    it do
      Facter.fact(:kernel).stubs(:value).returns('Solaris')

      Facter.fact(:megaraid_physical_drives_size).value.should be_nil
    end
  end # not on linux
end

