# frozen_string_literal: true

Facter.add(:megaraid_product_name) do
  confine :megacli_legacy => false

  megacli = Facter.value(:megacli)
  setcode do
    next if megacli.nil?

    output = Facter::Util::Resolution.exec("#{megacli} -Version -Ctrl -aALL -NoLog")
    next if output.nil?

    m = output.match(%r{Product Name\s*:\s*(.+)\s*$})
    next if m.nil?
    next unless m.size == 2

    m[1]
  end
end

Facter.add(:megaraid_product_name) do
  confine :megacli_legacy => true

  megacli = Facter.value(:megacli)
  setcode do
    next if megacli.nil?

    output = Facter::Util::Resolution.exec("#{megacli} -AdpAllInfo -aALL -NoLog")
    next if output.nil?

    m = output.match(%r{Product Name\s*:\s*(.+)\s*$})
    next if m.nil?
    next unless m.size == 2

    m[1]
  end
end
