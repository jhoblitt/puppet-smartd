Facter.add(:megacli) do
  confine :kernel => :linux

  setcode do
    Facter::Util::Resolution.which('MegaCli')
  end
end
