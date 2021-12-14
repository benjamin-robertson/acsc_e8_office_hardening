# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include acsc_e8_office_hardening::trusted_locations
class acsc_e8_office_hardening::trusted_locations (
  Hash $trusted_locations,
) {
  # Get length of trusted locations
  $hash_size = size($trusted_locations)
  $hash_size_array = Array($hash_size, false)
  # Set trusted locations
  $hash_size_array.each | Integer $index | {
    $_index = $index + 1
    notify { "index is ${_index}":}
  }

  $trusted_locations.each | String $name, Hash $location_data | {
    #notify { "index is ${index}":}
    acsc_e8_office_hardening::set_trusted_location {"location${name}":
      * => $location_data,
    }
  }

}
