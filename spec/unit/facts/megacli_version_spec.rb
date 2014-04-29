require 'spec_helper'

describe 'megacli_version', :type => :fact do
  before(:each) { Facter.clear }

  context 'megacli fact not set' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns(nil)
      Facter.fact(:megacli_version).value.should be_nil
    end
  end

  context 'megacli fact is broken' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns('foobar')
      Facter.fact(:megacli_version).value.should be_nil
    end
  end

  context 'megacli fact is working' do
    it 'should get the version string' do
      Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/bin/MegaCli -Version -Cli -aALL').
        returns(File.read(fixtures('megacli', 'version-cli-aall-8.07.07')))
      Facter.fact(:megacli_version).value.should == '8.07.07'
    end
  end

end

