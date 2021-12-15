# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include acsc_e8_office_hardening::clear_unused_registry_values
class acsc_e8_office_hardening::clear_unused_registry_values (
  String $system_setting,
  String $configured_setting,
) {
  # get system setting hash
  case $system_setting {
    'all_macros_disabled': {
      $existing_settings = lookup('acsc_e8_office_hardening::macros::all_disabled')
    }
    'macros_from_trused_locations': {
      $existing_settings = lookup('acsc_e8_office_hardening::macros::trusted_locations')
    }
    'signed_macros_only': {
      $existing_settings = lookup('acsc_e8_office_hardening::macros::signed_only')
    }
    default: { fail{'not a valid macro option':} }
  }

  # Get configured setting hash
  case $configured_setting {
    'all_macros_disabled': {
      $new_settings = lookup('acsc_e8_office_hardening::macros::all_disabled')
    }
    'macros_from_trused_locations': {
      $new_settings = lookup('acsc_e8_office_hardening::macros::trusted_locations')
    }
    'signed_macros_only': {
      $new_settings = lookup('acsc_e8_office_hardening::macros::signed_only')
    }
    default: { fail{'not a valid macro option':} }
  }

  # Delete the key no longer managed by puppet
  $keys_to_delete = $existing_settings - $new_settings

  notify {"My hash is now ${keys_to_delete}":}

  # Delete the keys
  $keys_to_delete.each | String $key_name, Hash $key_details | {
    case $key_details['class'] {
        'both': {
          # Delete machine registry keys
          registry_value { $key_name:
            ensure => absent,
            path   => "HKEY_LOCAL_MACHINE\\${key_name}",
          }
          # set user registry keys
          acsc_e8_office_hardening::delete_user_registry_value { $key_name:
            key_name    => $key_name,
          }
        }
        'user': {
          # set user registry keys
          acsc_e8_office_hardening::delete_user_registry_value { $key_name:
            key_name    => $key_name,
          }
        }
        'machine': {
          # set machine registry keys
          registry_value { $key_name:
            ensure => absent,
            path   => "HKEY_LOCAL_MACHINE\\${key_name}",
          }
        }
        default: { fail{'Registry key must specify a class, either both, user, machine.':} }
      }
  }

}
