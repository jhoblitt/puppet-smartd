# frozen_string_literal: true

require 'spec_helper'

describe 'megaraid_physical_drives', :type => :fact do
  before { Facter.clear }

  describe 'on linux' do
    context 'megacli not in path' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns(nil)

        expect(Facter.fact(:megaraid_physical_drives).value).to be_nil
      end
    end

    context 'megacli is broken' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns(nil)

        expect(Facter.fact(:megaraid_physical_drives).value).to be_nil
      end

      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('1')
        Facter::Util::Resolution.stubs(:exec).with('/usr/bin/MegaCli -PDList -aALL -NoLog').
          returns(nil)

        expect(Facter.fact(:megaraid_physical_drives).value).to be_nil
      end
    end

    context 'no adapters' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('0')

        expect(Facter.fact(:megaraid_physical_drives).value).to be_nil
      end
    end

    context '1 adapter' do
      let(:drives_list) do
        '10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,' \
          '32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,184,' \
          '185,188,189,190,192,194,197,199,200,201,202,203,204,205,206,207,' \
          '208,209,210,211,212,213,214'
      end

      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('1')
        Facter::Util::Resolution.stubs(:exec).with('/usr/bin/MegaCli -PDList -aALL -NoLog').
          returns(File.read(fixtures('megacli', 'pdlistaall')))

        expect(Facter.fact(:megaraid_physical_drives).value).to eq(drives_list)
      end
    end
  end

  context 'not on linux' do
    it do
      Facter.fact(:kernel).stubs(:value).returns('Solaris')

      expect(Facter.fact(:megaraid_physical_drives).value).to be_nil
    end
  end
end
