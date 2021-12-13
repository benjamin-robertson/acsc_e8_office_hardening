# @summary 
#
# Defined type which deletes registry value for each HKEY_CURRENT_USER on a machine. 
#
# @example
#   acsc_e8_office_hardening::user_registry_value { 'namevar': }
define acsc_e8_office_hardening::delete_user_registry_value (
  String $key_name,
) {

  $facts['local_sids'].each | String $sid | {
    registry_key { "${sid}\\${key_name}":
      ensure       => absent,
      path         => "HKEY_USERS\\${sid}\\${key_name}",
      purge_values => true,
    }
  }

}
