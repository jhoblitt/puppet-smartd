Facter.add(:megaraid_serial) do
  megacli = Facter.value(:megacli)

  setcode do
    unless megacli.nil?
      output = Facter::Util::Resolution.exec("#{megacli} -Version -Ctrl -aALL")
      next if output.nil?
      m = output.match(/Serial No : (\S+)\s*$/)
      next unless m.size == 2
      m[1]
    end
  end
end
