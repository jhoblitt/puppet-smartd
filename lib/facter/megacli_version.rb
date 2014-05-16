Facter.add(:megacli_version) do
  megacli = Facter.value(:megacli)

  setcode do
    unless megacli.nil?
      output = Facter::Util::Resolution.exec("#{megacli} -Version -Cli -aALL -NoLog")
      next if output.nil?
      m = output.match(/MegaCLI SAS RAID Management Tool  Ver ([\d\.]+)/)
      next unless m.size == 2
      m[1]
    end
  end
end
