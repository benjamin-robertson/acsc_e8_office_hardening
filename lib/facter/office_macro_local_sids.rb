# This fact is used to return a list of local SIDS so we can correctly
# process office macro rules.  These rules must be set for each USER/SID
# present inside HKEY_USER
Facter.add(:office_macro_local_sids) do
  confine kernel: 'windows'
  setcode do
    sid_list = []
    powershell = 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe'
    command = '(Get-ChildItem "REGISTRY::HKEY_USERS").name'
    value = Facter::Util::Resolution.exec(%(#{powershell} -command "#{command}"))
    value.split.each do |line|
      sid_list << line.split('\\')[1] if line.match?(%r{S\-1\-5\-.*\d$})
    end
    sid_list
  end
end
