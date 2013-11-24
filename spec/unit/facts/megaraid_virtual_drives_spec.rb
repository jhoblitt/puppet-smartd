require 'spec_helper'

describe 'megaraid_virtual_drives', :type => :fact do
  before(:each) { Facter.clear }

  describe 'on linux' do
    context 'megacli not in path' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns(nil)

        Facter.fact(:megaraid_virtual_drives).value.should be_nil
      end
    end

    context 'megacli is broken' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns(nil)

        Facter.fact(:megaraid_virtual_drives).value.should be_nil
      end

    end

    context 'no adapters' do
      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('0')

        Facter.fact(:megaraid_virtual_drives).value.should be_nil
      end
    end

    context '1 adapter' do
      before do
        facts = {
          :blockdevice_sda_model  => 'MR9286CV-8e',
          :blockdevice_sda_size   => '32001801322496',
          :blockdevice_sda_vendor => 'LSI',
          :blockdevice_sdb_model  => 'MR9286CV-8e',
          :blockdevice_sdb_size   => '32001801322496',
          :blockdevice_sdb_vendor => 'LSI',
          :blockdevice_sdc_model  => 'MR9286CV-8e',
          :blockdevice_sdc_size   => '32001801322496',
          :blockdevice_sdc_vendor => 'LSI',
          :blockdevice_sdd_model  => 'MR9286CV-8e',
          :blockdevice_sdd_size   => '32001801322496',
          :blockdevice_sdd_vendor => 'LSI',
          :blockdevice_sde_model  => 'MR9286CV-8e',
          :blockdevice_sde_size   => '199481098240',
          :blockdevice_sde_vendor => 'LSI',
          :blockdevice_sdf_model  => 'MR9286CV-8e',
          :blockdevice_sdf_size   => '32001801322496',
          :blockdevice_sdf_vendor => 'LSI',
          :blockdevice_sdg_model  => 'MR9286CV-8e',
          :blockdevice_sdg_size   => '32001801322496',
          :blockdevice_sdg_vendor => 'LSI',
          :blockdevice_sdh_model  => 'MR9286CV-8e',
          :blockdevice_sdh_size   => '199481098240',
          :blockdevice_sdh_vendor => 'LSI',
          :blockdevice_sdi_model  => 'INTEL SSDSC2CW12',
          :blockdevice_sdi_size   => '120034123776',
          :blockdevice_sdi_vendor => 'ATA',
          :blockdevice_sdj_model  => 'INTEL SSDSC2CW12',
          :blockdevice_sdj_size   => '120034123776',
          :blockdevice_sdj_vendor => 'ATA',
          :blockdevices           => 'sda,sdb,sdc,sdd,sde,sdf,sdg,sdh,sdi,sdj',
        }

        # stolen from rspec-puppet
        facts.each { |k, v| Facter.add(k) { setcode { v } }  }
      end

      it do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter.fact(:megacli).stubs(:value).returns('/usr/bin/MegaCli')
        Facter.fact(:megaraid_adapters).stubs(:value).returns('1')

        Facter.fact(:megaraid_virtual_drives).value.should == 'sda,sdb,sdc,sdd,sde,sdf,sdg,sdh'
      end
    end
  end # on linux

  context 'not on linux' do
    it do
      Facter.fact(:kernel).stubs(:value).returns('Solaris')

      Facter.fact(:megaraid_virtual_drives).value.should be_nil
    end
  end # not on linux
end
