# @summary A short summary of the purpose of this class
#
# A
# @example
#   include acsc_e8_office_hardening::macros
class acsc_e8_office_hardening::macros (
  String $macro_setting = 'all_macros_disabled',
) {
  assert_private()

  case $macro_setting {
    'all_macros_disabled': {
      $global_settings = lookup('acsc_e8_office_hardening::macros::all_disabled')
    }
    'macros_from_trused_locations': {
      $global_settings = lookup('acsc_e8_office_hardening::macros::trusted_locations')
    }
    'signed_macros_only': {
      $global_settings = lookup('acsc_e8_office_hardening::macros::signed_only')
    }
    default: { fail{'not a valid macro option':} }
  }

  $global_settings.each | String $key_name, Hash $key_details | {
    case $key_details['class'] {
      'both': {
        # set machine registry keys
        registry::value { $key_name:
          key   => "HKEY_LOCAL_MACHINE\\${key_details['key']}",
          value => $key_details['value'],
          type  => $key_details['type'],
          data  => $key_details['data'],
        }
        # set user registry keys
        acsc_e8_office_hardening::user_registry_value { $key_name:
          key_name    => $key_name,
          key_details => $key_details
        }
      }
      'user': {
        # set user registry keys
        acsc_e8_office_hardening::user_registry_value { $key_name:
          key_name    => $key_name,
          key_details => $key_details
        }
      }
      'machine': {
        # set machine registry keys
        registry::value { $key_name:
          key   => "HKEY_LOCAL_MACHINE\\${key_details['key']}",
          value => $key_details['value'],
          type  => $key_details['type'],
          data  => $key_details['data'],
        }
      }
      default: { fail{'Registry key must specify a class, either both, user, machine.':} }
    }
  }

  #notify {$macro_setting:
  #  message => $global_settings,
  #}
}
