# @summary A short summary of the purpose of this class
#
# Disables flash within office
#
# @example
#   include acsc_e8_office_hardening::disable_flash
class acsc_e8_office_hardening::disable_flash (
  Hash $reg_values,
) {

  $reg_values.each | String $name, Hash $values | {
    registry::value { $name:
      * => $values,
    }
  }
}
