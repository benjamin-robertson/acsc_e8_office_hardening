# @summary A short summary of the purpose of this class
#
# Mounts the default user ntuser.dat file located under c:\user\default\ntuser.dat
# Mounts under HKU\user_default
#
# @example
#   include acsc_e8_office_hardening::mount_default_user_hive
class acsc_e8_office_hardening::mount_default_user_hive {
  assert_private()

  # Check if we are mounting
  if $acsc_e8_office_hardening::set_ntuser_default {
    # Mount the default user registry hive
    exec { 'Mount regsitry hive':
      command => 'C:\\Windows\\system32\\reg.exe load HKU\\user_default C:\\Users\\Default\\NTUSER.DAT',
      unless  => 'C:\\Windows\\system32\\reg.exe query HKU\\user_default',
    }
  }

}
