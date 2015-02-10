require 'spec_helper'

describe 'megaraid_serial', :type => :fact do
  before(:each) { Facter.clear }

  context 'megacli fact not set' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns(nil)
      Facter.fact(:megaraid_serial).value.should be_nil
    end
  end

  context 'megacli fact is broken' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns('foobar')
      Facter.fact(:megaraid_serial).value.should be_nil
    end
  end

  context 'megacli fact is working' do
    context 'and modern' do
      it 'should get the serial number using modern binary' do
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megacli_legacy).stubs(:value).returns(false)
        Facter::Util::Resolution.stubs(:exec).
          with('/usr/bin/MegaCli -Version -Ctrl -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'version-ctrl-aall-8.07.07')))
        Facter.fact(:megaraid_serial).value.should == 'SV22925366'
      end

      context 'but megacli output is missing serial number' do
        it 'should return nil' do
          Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
          Facter.fact(:megacli_legacy).stubs(:value).returns(false)
          Facter::Util::Resolution.stubs(:exec).
            with('/usr/bin/MegaCli -Version -Ctrl -aALL -NoLog').
            returns(File.read(fixtures('megacli', 'version-ctrl-aall-sm_no_serial')))
          Facter.fact(:megaraid_serial).value.should be_nil
        end
      end
    end

    context 'and legacy' do
      it 'should get the serial number using legacy binary' do
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megacli_legacy).stubs(:value).returns(true)
        Facter::Util::Resolution.stubs(:exec).
          with('/usr/bin/MegaCli -AdpAllInfo -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'adpallinfo-aall-8.00.11')))
        Facter.fact(:megaraid_serial).value.should == '34A03AB'
      end

      context 'but megacli output is missing serial number' do
        it 'should return nil' do
          Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
          Facter.fact(:megacli_legacy).stubs(:value).returns(true)
          Facter::Util::Resolution.stubs(:exec).
            with('/usr/bin/MegaCli -AdpAllInfo -aALL -NoLog').
            returns(File.read(fixtures('megacli', 'adpallinfo-aall-8.00.11-dell_no_serial')))
          Facter.fact(:megaraid_serial).value.should be_nil
        end
      end
    end

  end

end

