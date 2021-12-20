# @summary 
#
# Defined type which sets registry value for each HKEY_CURRENT_USER on a machine. 
#
# @example
#   acsc_e8_office_hardening::user_registry_value { 'namevar': }
define acsc_e8_office_hardening::user_registry_value (
  String $key_name,
  Hash $key_details,
) {

  $all_sids = $facts['local_sids'] << 'louie'

  $all_sids.each | String $sid | {
    registry::value { "${sid}\\${key_name}":
      key   => "HKEY_USERS\\${sid}\\${key_details['key']}",
      value => $key_details['value'],
      type  => $key_details['type'],
      data  => $key_details['data'],
    }
  }

}
