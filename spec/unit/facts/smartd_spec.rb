require 'spec_helper'

describe 'smartd', :type => :fact do
  before(:each) { Facter.clear }

  context 'on linux' do
    context 'not in path' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux') 
        Facter::Util::Resolution.stubs(:which).with('smartd').returns(nil)
        Facter.fact(:smartd).value.should be_nil
      end
    end

    context 'in path' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux') 
        Facter::Util::Resolution.stubs(:which).with('smartd').returns('/usr/sbin/smartd')
        Facter.fact(:smartd).value.should == '/usr/sbin/smartd'
      end
    end
  end

end

