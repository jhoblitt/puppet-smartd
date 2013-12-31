# Figure out if this machine has AMI/LSI MegaRAID aka Dell PERC
# storage controllers, and if so, how many physical disks are
# attached.  Currently implemented only on Linux because none of
# our FreeBSD machines use these controllers, so I don't have an
# example "mfiutil show config" to write a parser for and test
# against.
def megacli_usable?
  (File.writable?('/dev/megaraid_sas_ioctl_node') or
      File.writable?('/dev/megadev0')) and
    Facter::Util::Resolution.which('MegaCli')
end

def lsscsi_usable?
    Facter::Util::Resolution.which('lsscsi')
end

Facter.add(:megaraid_physical_drives) do
  confine :kernel => [ :Linux ]  
  setcode do
    pds = []
    if megacli_usable?
      list = Facter::Util::Resolution.exec('MegaCli -PDList -aALL -NoLog')
      list.each_line do |line|
        if line =~ /^Device Id:\s+(\d+)/
          pds.push($1)
        end
      end
    end
    pds.sort.join(",")
  end
end

Facter.add(:megaraid_adapters) do
  confine :kernel => [ :Linux ]
  setcode do
    if megacli_usable?
      count = Facter::Util::Resolution.exec('MegaCli -adpCount -NoLog 2>&1')
      count =~ /Controller Count:\s+(\d+)\./ ? $1 : '0'
    else
      nil
    end
  end
end

# Try to figure out what should be used as the "device" parameter
# for smartd.  On FreeBSD it's simple, just use /dev/mfi%d, but
# on Linux we have to find a block device that corresponds to a
# *logical* drive on the controller.  Any logical drive will do,
# so long as it's on the same controller.  We only support one
# controller for now.
Facter.add(:megaraid_virtual_drives) do
  confine :kernel => [ :Linux ]
  setcode do
    if megacli_usable?
      list = Facter::Util::Resolution.exec('lsscsi | awk \'{ if($2 == "disk" && ($3 == "LSI" || $3 == "SMC")) { print $6 } }\'')
      list.map(&:chomp).sort.join(',')
    end
  end
end

# If this were implemented on FreeBSD, you would have two separate
# implementations: one that uses MegaCli (possibly under Linux emulation)
# for amr(4) controllers, and one that uses mfiutil(8) for mfi(4)
# controllers.
#Facter.add(:megaraid_physical_drives) do
#  confine :kernel => [ :FreeBSD ]
#  setcode do
#    pds = []
#    mfiutil = Facter::Util::Resolution.which('mfiutil')
#    if File.writable?('/dev/mfi0') and mfiutil
#      list = Facter::Util::Resolution.exec(mfiutil + ' show config'
#      # do something here
#    end
#    pds.join(",")
#  end
#end

Facter.add(:megaraid_adapters) do
  confine :kernel => [ :FreeBSD ]
  setcode do
    Dir.glob('/dev/mfi[0-9]*').size + Dir.glob('/dev/amr[0-9]*').size
  end
end

# I don't know if smartmontools even supports talking to this
# interface, but assume that it works like HPTRR and similar
# hardware RAID controllers.  Only one controller is supported.
Facter.add(:megaraid_smartd_device_name) do
  confine :kernel => [ :FreeBSD ]
  setcode do
    (Dir.glob('/dev/mfi[0-9]*') + Dir.glob('/dev/amr[0-9]*'))[0]
  end
end
