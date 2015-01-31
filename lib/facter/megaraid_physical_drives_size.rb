Facter.add(:megaraid_physical_drives_size) do
  confine :kernel => 'Linux'

  setcode do
    megacli           = Facter.value(:megacli)
    megaraid_adapters = Facter.value(:megaraid_adapters)

    if megacli.nil? ||
      megaraid_adapters.nil? || (megaraid_adapters == 0)
      next nil
    end

    # XXX there is no support for handling more than one adapter
    sizes = []
    list = Facter::Util::Resolution.exec("#{megacli} -PDList -aALL -NoLog")
    next if list.nil?
    list.each_line do |line|
      if line =~ /Raw Size: ([\.\d]+ [A-Z]?B)/
        sizes.push($1)
      end
    end

    sizes.join(',')
  end
end
