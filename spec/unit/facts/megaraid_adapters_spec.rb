require 'spec_helper'

describe 'megaraid_adapters', :type => :fact do
  before(:each) { Facter.clear }

  context 'on linux' do
    context 'megacli not in path' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns(nil)

        expect(Facter.fact(:megaraid_adapters).value).to be_nil
      end
    end

    context 'megacli is broken' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter::Util::Resolution.stubs(:exec).with('/usr/bin/MegaCli -adpCount -NoLog 2>&1').
          returns(nil)

        expect(Facter.fact(:megaraid_adapters).value).to  eq('0')
      end
    end

    context 'megacli is working' do
      it 'should find 0 adapters' do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter::Util::Resolution.stubs(:which).with('MegaCli').returns('/usr/bin/MegaCli')
        Facter::Util::Resolution.stubs(:exec).with('/usr/bin/MegaCli -adpCount -NoLog 2>&1').
          returns(File.read(fixtures('megacli', 'adpcount-count_0')))

        expect(Facter.fact(:megaraid_adapters).value).to  eq('0')
      end

      it 'should find 1 adapters' do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter::Util::Resolution.stubs(:which).with('MegaCli').returns('/usr/bin/MegaCli')
        Facter::Util::Resolution.stubs(:exec).with('/usr/bin/MegaCli -adpCount -NoLog 2>&1').
          returns(File.read(fixtures('megacli', 'adpcount-count_1')))

        expect(Facter.fact(:megaraid_adapters).value).to  eq('1')
      end
    end
  end # on linux

  context 'not on linux' do
    it do
      Facter.fact(:kernel).stubs(:value).returns('Solaris')

      expect(Facter.fact(:megaraid_adapters).value).to be_nil
    end
  end # not on linux

end
