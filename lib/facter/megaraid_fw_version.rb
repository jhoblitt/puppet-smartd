Facter.add(:megaraid_fw_version) do
  megacli = Facter.value(:megacli)

  setcode do
    unless megacli.nil?
      output = Facter::Util::Resolution.exec("#{megacli} -Version -Ctrl -aALL")
      next if output.nil?
      m = output.match(/FW Version : ([\d\.\-]+)\s*$/)
      next unless m.size == 2
      m[1]
    end
  end
end
