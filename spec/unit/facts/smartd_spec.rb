# frozen_string_literal: true

require 'spec_helper'

describe 'smartd', :type => :fact do
  before { Facter.clear }

  context 'not in path' do
    it do
      Facter::Util::Resolution.stubs(:which).with('smartd').returns(nil)
      expect(Facter.fact(:smartd).value).to be_nil
    end
  end

  context 'in path' do
    it do
      Facter::Util::Resolution.stubs(:which).with('smartd').returns('/usr/sbin/smartd')
      expect(Facter.fact(:smartd).value).to eq('/usr/sbin/smartd')
    end
  end
end
