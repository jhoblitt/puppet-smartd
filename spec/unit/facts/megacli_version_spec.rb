# frozen_string_literal: true

require 'spec_helper'

describe 'megacli_version', :type => :fact do
  before { Facter.clear }

  context 'megacli fact not set' do
    it 'returns nil' do
      Facter.fact(:megacli).stubs(:value).returns(nil)
      expect(Facter.fact(:megacli_version).value).to be_nil
    end
  end

  context 'megacli fact is broken' do
    it 'returns nil' do
      Facter.fact(:megacli).stubs(:value).returns('foobar')
      expect(Facter.fact(:megacli_version).value).to be_nil
    end
  end

  context 'megacli fact is working' do
    it 'gets the version string using modern binary' do
      Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/bin/MegaCli -Version -Cli -aALL -NoLog').
        returns(File.read(fixtures('megacli', 'version-cli-aall-8.07.07')))
      expect(Facter.fact(:megacli_version).value).to eq('8.07.07')
    end

    it 'gets the version string using legacy binary' do
      Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/bin/MegaCli -Version -Cli -aALL -NoLog').
        returns(File.read(fixtures('megacli', 'invalid-input-8.00.11')))
      Facter::Util::Resolution.stubs(:exec).
        with('/usr/bin/MegaCli -v -aALL -NoLog').
        returns(File.read(fixtures('megacli', 'version-aall-8.00.11')))
      expect(Facter.fact(:megacli_version).value).to eq('8.00.11')
    end
  end
end
