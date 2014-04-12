Facter.add(:smartmontools_version) do
  smartd = Facter.value(:smartd)
  setcode do
    unless smartd.nil?
      output = Facter::Util::Resolution.exec("#{smartd} --version")
      next if output.nil?
      m = output.match(/smartmontools release ([\d\.]+)/)
      next unless m.size == 2
      m[1]
    end
  end
end
