# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include acsc_e8_office_hardening::trusted_locations
class acsc_e8_office_hardening::trusted_locations (
  Hash $trusted_locations,
) {
  $lambda_count = 1
  $trusted_locations.each | String $name, Hash $location_data | {
    set_trusted_location {"location${lambda_count}":
      * => $location_data,
    }
    $lambda_count = $lambda_count + 1
  }
}
