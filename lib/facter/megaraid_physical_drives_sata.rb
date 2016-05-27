Facter.add(:megaraid_physical_drives_sata) do
  confine :kernel => 'Linux'

  setcode do
    megacli           = Facter.value(:megacli)
    megaraid_adapters = Facter.value(:megaraid_adapters)

    next if megacli.nil? || megaraid_adapters.nil? || (megaraid_adapters == 0)

    # XXX there is no support for handling more than one adapter
    pds = []
    list = Facter::Util::Resolution.exec("#{megacli} -PDList -aALL -NoLog")
    next if list.nil?

    dev_id = nil
    list.each_line do |line|
      dev_id = Regexp.last_match(1) if line =~ /^Device Id:\s+(\d+)/
      if line =~ /^PD Type:\s+(\w+)/
        type = Regexp.last_match(1)
        pds.push(dev_id) if type == 'SATA'
      end
    end

    # sort the device IDs numerically on the assumption that they are always
    # integers
    pds.sort { |a, b| a.to_i <=> b.to_i }.join(',')
  end
end
