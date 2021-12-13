# @summary A short summary of the purpose of this class
#
# A module which enforces https://www.cyber.gov.au/sites/default/files/2021-10/PROTECT%20-%20Hardening%20Microsoft%20365%2C%20Office%202021%2C%20Office%202019%20and%20Office%202016%20%28October%202021%29.pdf
#
# @example
#   include acsc_e8_office_hardening
class acsc_e8_office_hardening (
  Boolean $disable_flash_content = true,
  Boolean $diable_macros = true,
  Enum['all_macros_disabled','macros_from_trused_locations','signed_macros_only','clear_macro_settings'] $macro_setting = 'clear_macro_settings', # lint:ignore:140chars
  Variant[Undef,Hash] $trusted_locations = undef,
) {

  if $disable_flash_content {
    include acsc_e8_office_hardening::disable_flash
  }

  if $diable_macros {
    class { 'acsc_e8_office_hardening::macros':
      macro_setting => $macro_setting,
    }
  }

  if $trusted_locations {
    notify {'Trusted locations set':}
  }

}
