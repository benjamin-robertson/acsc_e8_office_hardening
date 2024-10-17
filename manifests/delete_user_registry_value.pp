# @summary Private type
#
# Defined type which deletes registry value for each HKEY_CURRENT_USER on a machine. 
#
# @example
#   acsc_e8_office_hardening::user_registry_value { 'key_name': }
#
# @param [String] key_name
#   key name to delete
define acsc_e8_office_hardening::delete_user_registry_value (
  String $key_name,
) {
  # Check if we are setting the user default
  if $acsc_e8_office_hardening::set_ntuser_default {
    $all_sids = $facts['office_macro_local_sids'] << 'user_default'
  } else {
    $all_sids = $facts['office_macro_local_sids']
  }

  $all_sids.each | String $sid | {
    registry_value { "${sid}\\${key_name}":
      ensure => absent,
      path   => "HKEY_USERS\\${sid}\\${key_name}",
    }
  }
}
