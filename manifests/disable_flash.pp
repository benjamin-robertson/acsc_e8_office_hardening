# @summary Private class
#
# Disables flash within office
#
# @example
#   include acsc_e8_office_hardening::disable_flash
#
# @param [Hash] reg_values
#    registry values to set
class acsc_e8_office_hardening::disable_flash (
  Hash $reg_values,
) {
  $reg_values.each | String $name, Hash $values | {
    registry::value { $name:
      * => $values,
    }
  }
}
