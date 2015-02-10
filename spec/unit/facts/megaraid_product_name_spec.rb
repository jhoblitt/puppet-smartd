require 'spec_helper'

describe 'megaraid_product_name', :type => :fact do
  before(:each) { Facter.clear }

  context 'megacli fact not set' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns(nil)
      Facter.fact(:megaraid_product_name).value.should be_nil
    end
  end

  context 'megacli fact is broken' do
    it 'should return nil' do
      Facter.fact(:megacli).stubs(:value).returns('foobar')
      Facter.fact(:megaraid_product_name).value.should be_nil
    end
  end

  context 'megacli fact is working' do
    context 'and modern' do
      it 'should get the product name string using the modern binary' do
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megacli_legacy).stubs(:value).returns(false)
        Facter::Util::Resolution.stubs(:exec).
          with('/usr/bin/MegaCli -Version -Ctrl -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'version-ctrl-aall-8.07.07')))
        Facter.fact(:megaraid_product_name).value.should == 'LSI MegaRAID SAS 9286CV-8e'
      end
    end

    context 'and legacy' do
      it 'should get the product name string using legacy binary' do
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megacli_legacy).stubs(:value).returns(true)
        Facter::Util::Resolution.stubs(:exec).
          with('/usr/bin/MegaCli -AdpAllInfo -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'adpallinfo-aall-8.00.11')))
        Facter.fact(:megaraid_product_name).value.should == 'PERC H310 Mini'
      end
    end
  end

end

