# frozen_string_literal: true

Facter.add(:megaraid_physical_drives_size) do
  confine :kernel => 'Linux'

  setcode do
    megacli           = Facter.value(:megacli)
    megaraid_adapters = Facter.value(:megaraid_adapters)

    next if megacli.nil? || megaraid_adapters.nil? || megaraid_adapters.zero?

    # XXX there is no support for handling more than one adapter
    sizes = []
    list = Facter::Util::Resolution.exec("#{megacli} -PDList -aALL -NoLog")
    next if list.nil?

    list.each_line do |line|
      sizes.push(Regexp.last_match(1)) if line =~ %r{Raw Size: ([.\d]+ [A-Z]?B)}
    end

    sizes.join(',')
  end
end
