# frozen_string_literal: true

# Figure out if this machine has AMI/LSI MegaRAID aka Dell PERC
# storage controllers, and if so, how many physical disks are
# attached.  Currently implemented only on Linux because none of
# our FreeBSD machines use these controllers, so I don't have an
# example "mfiutil show config" to write a parser for and test
# against.

Facter.add(:megaraid_adapters) do
  confine :kernel => 'Linux'

  setcode do
    megacli = Facter.value(:megacli)

    next if megacli.nil?

    # -adpCount sends it's entire output to the stderr
    count = Facter::Util::Resolution.exec("#{megacli} -adpCount -NoLog 2>&1")
    count =~ %r{Controller Count:\s+(\d+)\.} ? Regexp.last_match(1) : '0'
  end
end
