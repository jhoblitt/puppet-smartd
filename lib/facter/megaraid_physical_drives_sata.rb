Facter.add(:megaraid_physical_drives_sata) do
  confine :kernel => 'Linux'

  setcode do
    megacli           = Facter.value(:megacli)
    megaraid_adapters = Facter.value(:megaraid_adapters)

    if megacli.nil? ||
      megaraid_adapters.nil? || (megaraid_adapters == 0)
      next nil
    end

    # XXX there is no support for handling more than one adapter
    pds = []
    list = Facter::Util::Resolution.exec("#{megacli} -PDList -aALL -NoLog")
    next if list.nil?

    dev_id = nil
    list.each_line do |line|
      if line =~ /^Device Id:\s+(\d+)/
        dev_id = $1
      end
      if line =~ /^PD Type:\s+(\w+)/
        type = $1
        if type == 'SATA'
          pds.push(dev_id)
        end
      end
    end

    # sort the device IDs numerically on the assumption that they are always
    # integers
    pds.sort {|a,b| a.to_i <=> b.to_i}.join(",")
  end
end
