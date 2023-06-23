# frozen_string_literal: true

Facter.add(:megacli_version) do
  megacli = Facter.value(:megacli)
  version_commands = ["#{megacli} -Version -Cli -aALL -NoLog",
                      "#{megacli} -v -aALL -NoLog"]

  setcode do
    next if megacli.nil?

    version = nil
    # This is a bit hacky, but we need to try different commands to ascertain
    # the version of the megacli binary.
    version_commands.each do |cmd|
      output = Facter::Util::Resolution.exec(cmd)
      next if output.nil?

      m = output.match(%r{MegaCLI SAS RAID Management Tool  Ver ([\d.]+)})
      next if m.nil?
      next unless m.size == 2

      version = m[1]
      break
    end
    version
  end
end
