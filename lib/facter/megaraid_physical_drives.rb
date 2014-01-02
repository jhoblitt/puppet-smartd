Facter.add(:megaraid_physical_drives) do
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
    list.each_line do |line|
      if line =~ /^Device Id:\s+(\d+)/
        pds.push($1)
      end
    end

    # sort the device IDs numerically on the assumption that they are always
    # integers
    pds.sort {|a,b| a.to_i <=> b.to_i}.join(",")
  end
end
