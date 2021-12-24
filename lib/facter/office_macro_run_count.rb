# frozen_string_literal: true

Facter.add(:office_macro_run_count) do
  # https://puppet.com/docs/puppet/latest/fact_overview.html
  setcode do
    value = 0
    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Puppet Labs\Puppet') do |reg|
        value = reg['office_macro_run_count']
      end
    rescue
      value = 0
    end
    value
  end
end
