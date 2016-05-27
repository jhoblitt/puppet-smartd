# Try to figure out what should be used as the "device" parameter
# for smartd.  On FreeBSD it's simple, just use /dev/mfi%d, but
# on Linux we have to find a block device that corresponds to a
# *logical* drive on the controller.  Any logical drive will do,
# so long as it's on the same controller.  We only support one
# controller for now.
Facter.add(:megaraid_virtual_drives) do
  confine :kernel => 'Linux'

  setcode do
    megacli           = Facter.value(:megacli)
    megaraid_adapters = Facter.value(:megaraid_adapters)
    blockdevices      = Facter.value(:blockdevices)

    next if megacli.nil? || megaraid_adapters.nil? ||
            (megaraid_adapters == 0) || blockdevices.nil?

    vds = []

    devices = blockdevices.split(',')
    devices.each do |dev|
      vendor = Facter.value("blockdevice_#{dev}_vendor")
      case vendor
      when 'LSI', 'SMC', 'DELL'
        vds << dev
      end
    end

    next if vds.empty?
    vds.sort.join(',')
  end
end
