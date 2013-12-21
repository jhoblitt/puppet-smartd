require 'spec_helper'

describe 'megacli', :type => :fact do
  before(:each) { Facter.clear }

  context 'on linux' do
    context 'not in path' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux') 
        Facter::Util::Resolution.stubs(:which).with('MegaCli').returns(nil)
        Facter.fact(:megacli).value.should be_nil
      end
    end

    context 'in path' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux') 
        Facter::Util::Resolution.stubs(:which).with('MegaCli').returns('/usr/bin/MegaCli')
        Facter.fact(:megacli).value.should == '/usr/bin/MegaCli'
      end
    end
  end

end

