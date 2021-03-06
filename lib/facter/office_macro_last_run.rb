# frozen_string_literal: true

Facter.add(:office_macro_last_run) do
  confine kernel: 'windows'
  setcode do
    value = ''
    begin
      Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Puppet Labs\Puppet') do |reg|
        value = reg['office_macro_last_run']
      end
    rescue
      value = 'first_run'
    end
    value
  end
end
