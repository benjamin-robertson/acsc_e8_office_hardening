# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include acsc_e8_office_hardening::trusted_locations
class acsc_e8_office_hardening::trusted_locations (
  Hash $trusted_locations,
) {
  # Get hash keys as an array
  $hash_keys = keys($trusted_locations)
  # Set trusted locations
  notify {"Trusted location ${trusted_locations}":}
  $hash_keys.each | Integer $index, String $name | {
    $_index = $index + 1
    acsc_e8_office_hardening::set_trusted_location {"location${_index}":
      * => $trusted_locations[$name],
    }
  }

  # Delete unmanaged locations
  $hash_length = size($trusted_locations)
  $elements_to_delete = 20 - $hash_length
  # Create 20 length array
  $delete_array = Array($elements_to_delete, false)

  $delete_array.each | Integer $index | {
    $delelete_index = 20 - $index
    #notify {"Deleting location${delelete_index}":}
    acsc_e8_office_hardening::delete_trusted_location { "location${delelete_index}":}
  }

}
