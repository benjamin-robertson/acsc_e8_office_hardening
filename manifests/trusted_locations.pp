# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include acsc_e8_office_hardening::trusted_locations
class acsc_e8_office_hardening::trusted_locations (
  Hash $trusted_locations,
) {
  # Check there are less than
  # Get hash keys as an array
  $hash_keys = keys($trusted_locations)
  notify { "hash keys is ${hash_keys}":}
  # Set trusted locations
  $hash_keys.each | Integer $index, String $name | {
    $_index = $index + 1
    acsc_e8_office_hardening::set_trusted_location {"location${_index}":
      * => $trusted_locations[$name],
    }

  }
}
