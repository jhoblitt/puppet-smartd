Facter.add(:smartd) do
  confine :kernel => :linux

  setcode do
    Facter::Util::Resolution.which('smartd')
  end
end
