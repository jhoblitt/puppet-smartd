require 'spec_helper'

describe 'megaraid_fw_package_build', :type => :fact do
  before(:each) { Facter.clear }

  context 'megacli fact not set' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns(nil)
      Facter.fact(:megaraid_fw_package_build).value.should be_nil
    end
  end

  context 'megacli fact is broken' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns('foobar')
      Facter.fact(:megaraid_fw_package_build).value.should be_nil
    end
  end

  context 'megacli fact is working' do
    context 'and modern' do
      it 'should get the version string using modern binary' do
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megacli_legacy).stubs(:value).returns(false)
        Facter::Util::Resolution.stubs(:exec).
          with('/usr/bin/MegaCli -Version -Ctrl -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'version-ctrl-aall-8.07.07')))
        Facter.fact(:megaraid_fw_package_build).value.should == '23.22.0-0012'
      end
    end

    context 'and legacy' do
      it 'should get the version string using legacy binary' do
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megacli_legacy).stubs(:value).returns(true)
        Facter::Util::Resolution.stubs(:exec).
          with('/usr/bin/MegaCli -AdpAllInfo -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'adpallinfo-aall-8.00.11')))
        Facter.fact(:megaraid_fw_package_build).value.should == '20.12.0-0004'
      end
    end
  end

end
