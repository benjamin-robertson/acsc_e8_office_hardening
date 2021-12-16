# @summary A short summary of the purpose of this class
#
# A module which enforces https://www.cyber.gov.au/sites/default/files/2021-10/PROTECT%20-%20Hardening%20Microsoft%20365%2C%20Office%202021%2C%20Office%202019%20and%20Office%202016%20%28October%202021%29.pdf
#
# @example
#   include acsc_e8_office_hardening
class acsc_e8_office_hardening (
  Boolean $disable_flash_content = true,
  Boolean $disable_macros = true,
  Enum['all_macros_disabled','macros_from_trused_locations','signed_macros_only','clear_macro_settings'] $macro_setting = 'clear_macro_settings', # lint:ignore:140chars
  Variant[Undef,Hash[String,Hash,1,20]] $trusted_locations = undef,
) {

  # Set run status
  registry::value { 'acsc_e8_office_hardening_last_run_option':
    key   => 'HKLM\\SOFTWARE\\Puppet Labs\\Puppet',
    value => 'office_macro_last_run',
    type  => 'string',
    data  => $macro_setting,
  }

  # Check if this is the first run of acsc_e8_office_hardening
  if $facts['office_macro_last_run'] != 'clear_macro_settings' {
    if $facts['office_macro_last_run'] != 'first_run' {
      # confirm we are not clearing macro all macro settings
      if $macro_setting != 'clear_macro_settings' {
        # this is not our first run check if the macro_setting has changed.
        if $facts['office_macro_last_run'] != $macro_setting {
          # Need to delete the non requried registry keys
          class { 'acsc_e8_office_hardening::clear_unused_registry_values':
            system_setting     => $facts['office_macro_last_run'],
            configured_setting => $macro_setting,
          }
          #Class['acsc_e8_office_hardening::clear_unused_registry_values'] -> Class['acsc_e8_office_hardening::macros'] # lint:ignore:140chars
        }
      }
    }
  }

  if $disable_flash_content {
    include acsc_e8_office_hardening::disable_flash
  }

  if $disable_macros {
    class { 'acsc_e8_office_hardening::macros':
      macro_setting => $macro_setting,
    }
  }

  if $macro_setting == 'macros_from_trused_locations' {
    class { 'acsc_e8_office_hardening::trusted_locations':
      trusted_locations => $trusted_locations,
    }
  }

}
