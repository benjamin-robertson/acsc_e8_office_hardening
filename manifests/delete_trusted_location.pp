# @summary Private class
#
# Delete trusted location if unmanaged by Pupppet
# We handle up to 20 custom locations
#
# @example
#   acsc_e8_office_hardening::delete_trusted_location { "location${delelete_index}":}
define acsc_e8_office_hardening::delete_trusted_location (
) {

  $locations = lookup(acsc_e8_office_hardening::set_trusted_location::locations)

  # Check if we are setting the user default
  if $acsc_e8_office_hardening::set_ntuser_default {
    $all_sids = $facts['local_sids'] << 'user_default'
  } else {
    $all_sids = $facts['local_sids']
  }

  $all_sids.each | String $sid | {
    # Delete location
    $locations.each | String $location_value | {
      registry_key { "${sid}\\${location_value}${name}":
        ensure => absent,
        path   => "HKEY_USERS\\${sid}\\${location_value}${name}",
      }
    }
  }
}
