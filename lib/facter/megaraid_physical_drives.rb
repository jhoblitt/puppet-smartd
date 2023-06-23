# frozen_string_literal: true

Facter.add(:megaraid_physical_drives) do
  confine :kernel => 'Linux'

  setcode do
    megacli           = Facter.value(:megacli)
    megaraid_adapters = Facter.value(:megaraid_adapters)

    next if megacli.nil? || megaraid_adapters.nil? || megaraid_adapters.zero?

    # XXX there is no support for handling more than one adapter
    pds = []
    list = Facter::Util::Resolution.exec("#{megacli} -PDList -aALL -NoLog")
    next if list.nil?

    list.each_line do |line|
      pds.push(Regexp.last_match(1)) if line =~ %r{^Device Id:\s+(\d+)}
    end

    # sort the device IDs numerically on the assumption that they are always
    # integers
    pds.sort_by(&:to_i).join(',')
  end
end
