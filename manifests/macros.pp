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

  notify {$global_settings:}
}
