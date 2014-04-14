Facter.add(:smartd) do
  setcode do
    Facter::Util::Resolution.which('smartd')
  end
end
