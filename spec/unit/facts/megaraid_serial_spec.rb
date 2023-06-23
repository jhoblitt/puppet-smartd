# frozen_string_literal: true

require 'spec_helper'

describe 'megaraid_serial', :type => :fact do
  before { Facter.clear }

  context 'megacli fact not set' do
    it 'returns nil' do
      Facter.fact(:megacli).stubs(:value).returns(nil)
      expect(Facter.fact(:megaraid_serial).value).to be_nil
    end
  end

  context 'megacli fact is broken' do
    it 'returns nil' do
      Facter.fact(:megacli).stubs(:value).returns('foobar')
      expect(Facter.fact(:megaraid_serial).value).to be_nil
    end
  end

  context 'megacli fact is working' do
    context 'and modern' do
      it 'gets the serial number using modern binary' do
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megacli_legacy).stubs(:value).returns(false)
        Facter::Util::Resolution.stubs(:exec).
          with('/usr/bin/MegaCli -Version -Ctrl -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'version-ctrl-aall-8.07.07')))
        expect(Facter.fact(:megaraid_serial).value).to eq('SV22925366')
      end

      context 'but megacli output is missing serial number' do
        it 'returns nil' do
          Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
          Facter.fact(:megacli_legacy).stubs(:value).returns(false)
          Facter::Util::Resolution.stubs(:exec).
            with('/usr/bin/MegaCli -Version -Ctrl -aALL -NoLog').
            returns(File.read(fixtures('megacli', 'version-ctrl-aall-sm_no_serial')))
          expect(Facter.fact(:megaraid_serial).value).to be_nil
        end
      end
    end

    context 'and legacy' do
      it 'gets the serial number using legacy binary' do
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megacli_legacy).stubs(:value).returns(true)
        Facter::Util::Resolution.stubs(:exec).
          with('/usr/bin/MegaCli -AdpAllInfo -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'adpallinfo-aall-8.00.11')))
        expect(Facter.fact(:megaraid_serial).value).to eq('34A03AB')
      end

      context 'but megacli output is missing serial number' do
        it 'returns nil' do
          Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
          Facter.fact(:megacli_legacy).stubs(:value).returns(true)
          Facter::Util::Resolution.stubs(:exec).
            with('/usr/bin/MegaCli -AdpAllInfo -aALL -NoLog').
            returns(File.read(fixtures('megacli', 'adpallinfo-aall-8.00.11-dell_no_serial')))
          expect(Facter.fact(:megaraid_serial).value).to be_nil
        end
      end
    end
  end
end
