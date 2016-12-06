Facter.add(:megacli) do
  confine :kernel => :linux

  megacli_binaries = %w(MegaCli megacli)

  setcode do
    path = nil
    megacli_binaries.each do |bin|
      path = Facter::Util::Resolution.which(bin)
      next if path.nil?
      break
    end
    path
  end
end
