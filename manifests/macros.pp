# @summary A short summary of the purpose of this class
#
# Configured office macro settings for office.
# Private class
# 
# @example
#   include acsc_e8_office_hardening::macros
#
# @param [String] macro_setting
#   set office macro setting
class acsc_e8_office_hardening::macros (
  String $macro_setting = 'clear_macro_settings',
) {
  assert_private()

  case $macro_setting {
    'all_macros_disabled': {
      $global_settings = lookup('acsc_e8_office_hardening::macros::all_disabled')
      $clear_macro_settings = false
    }
    'macros_from_trused_locations': {
      $global_settings = lookup('acsc_e8_office_hardening::macros::trusted_locations')
      $clear_macro_settings = false
    }
    'signed_macros_only': {
      $global_settings = lookup('acsc_e8_office_hardening::macros::signed_only')
      $clear_macro_settings = false
    }
    'clear_macro_settings': {
      $clear_macro_settings = true
    }
    default: { fail{'not a valid macro option':} }
  }

  if $clear_macro_settings {
    # We will delete all the registry keys set by Puppet
    $reg_val_1 = lookup('acsc_e8_office_hardening::macros::all_disabled')
    $reg_val_2 = lookup('acsc_e8_office_hardening::macros::trusted_locations')
    $reg_val_3 = lookup('acsc_e8_office_hardening::macros::signed_only')
    # merge all hashes together
    $reg_merged = merge($reg_val_1, $reg_val_2, $reg_val_3)

    # Unpack the hash
    $reg_merged.each | String $key_name, Hash $key_details | {
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

  } else {
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
  }

}
