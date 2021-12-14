# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include acsc_e8_office_hardening::trusted_locations
class acsc_e8_office_hardening::trusted_locations (
  Hash $trusted_locations,
) {
  $trusted_locations.each | String $name, Hash $location_data | {
    acsc_e8_office_hardening::set_trusted_location {"location${name}":
      * => $location_data,
    }
  }
}
