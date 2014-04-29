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
    it 'should get the version string' do
      Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/bin/MegaCli -Version -Ctrl -aALL').
        returns(File.read(fixtures('megacli', 'version-ctrl-aall-8.07.07')))
      Facter.fact(:megaraid_fw_package_build).value.should == '23.22.0-0012'
    end
  end

end

