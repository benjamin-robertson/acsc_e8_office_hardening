# @summary Private class
#
# Mounts the default user ntuser.dat file located under c:\user\default\ntuser.dat
# Mounts under HKU\user_default
# Private class
#
# @example
#   include acsc_e8_office_hardening::unmount_default_user_hive
class acsc_e8_office_hardening::unmount_default_user_hive {
  assert_private()

  # Check if we are mounting
  if $acsc_e8_office_hardening::set_ntuser_default {
    # Mount the default user registry hive
    exec { 'Unmount regsitry hive':
      command => 'C:\\Windows\\system32\\reg.exe unload HKU\\user_default',
      onlyif  => 'C:\\Windows\\system32\\reg.exe query HKU\\user_default',
    }
  }
}
