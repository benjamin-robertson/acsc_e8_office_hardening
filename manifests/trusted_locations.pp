# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include acsc_e8_office_hardening::trusted_locations
class acsc_e8_office_hardening::trusted_locations (
  Hash $trusted_locations,
) {
  # Set trusted locations
  $trusted_locations.each | String $name, Hash $location_data | {
    notify { "index is ${index}":}
    acsc_e8_office_hardening::set_trusted_location {"location${name}":
      * => $location_data,
    }
  }

  # Unset any unmanaged locations
  $hash_size = size($trusted_locations)
  notify {"size is ${hash_size}": }
  $myarray = Array($hash_size, true)
  notify {"arry is ${myarray}":}
}
