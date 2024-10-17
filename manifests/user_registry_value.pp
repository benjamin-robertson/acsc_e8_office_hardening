# @summary Private type
#
# Defined type which sets registry value for each HKEY_CURRENT_USER on a machine. 
#
# @example
#   acsc_e8_office_hardening::user_registry_value { 'namevar': }
#
# @param [String] key_name
#   key name
# @param [Hash] key_details
#   Key details, hash containing value, type and data for registry value
define acsc_e8_office_hardening::user_registry_value (
  String $key_name,
  Hash $key_details,
) {
  # Check if we are setting the user default
  if $acsc_e8_office_hardening::set_ntuser_default {
    $all_sids = $facts['office_macro_local_sids'] << 'user_default'
  } else {
    $all_sids = $facts['office_macro_local_sids']
  }

  $all_sids.each | String $sid | {
    registry::value { "${sid}\\${key_name}":
      key   => "HKEY_USERS\\${sid}\\${key_details['key']}",
      value => $key_details['value'],
      type  => $key_details['type'],
      data  => $key_details['data'],
    }
  }
}
