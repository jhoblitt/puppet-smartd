Facter.add(:megaraid_fw_package_build) do
  megacli = Facter.value(:megacli)

  setcode do
    unless megacli.nil?
      output = Facter::Util::Resolution.exec("#{megacli} -Version -Ctrl -aALL -NoLog")
      next if output.nil?
      m = output.match(/Fw Package Build : ([\d\.\-]+)\s*$/)
      next unless m.size == 2
      m[1]
    end
  end
end
