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

    if megacli.nil?
      next nil
    end

    # -adpCount sends it's entire output to the stderr
    count = Facter::Util::Resolution.exec("#{megacli} -adpCount -NoLog 2>&1")
    count =~ /Controller Count:\s+(\d+)\./ ? $1 : '0'
  end
end
