# @summary A short summary of the purpose of this defined type.
#
# Creates trusted location for office files.
# This must be used in conjuntion with the macros_from_trused_locations option. 
# Otherwise it will have affect. 
#
# @example
#   acsc_e8_office_hardening::set_trusted_location { 'namevar': }
define acsc_e8_office_hardening::set_trusted_location (
  String $path,
  Optional[Variant[String,Undef]] $date = undef,
  Optional[Variant[String,Undef]] $description = undef,
  Optional[Boolean] $allowsub = false,
) {

  $locations = lookup(acsc_e8_office_hardening::set_trusted_location::locations)

  $all_sids = $facts['local_sids'] << 'user_default'

  $all_sids.each | String $sid | {
    $locations.each | String $location_value | {
      # set path
      registry::value { "${sid}\\${location_value}${name}\\path":
        key   => "HKEY_USERS\\${sid}\\${location_value}${name}",
        value => 'path',
        type  => 'expand',
        data  => $path,
      }
      # Set date if requried
      if $date {
        registry::value { "${sid}\\${location_value}${name}\\date":
          key   => "HKEY_USERS\\${sid}\\${location_value}${name}",
          value => 'date',
          type  => 'string',
          data  => $date,
        }
      }
      # set description if required
      if $description {
        registry::value { "${sid}\\${location_value}${name}\\description":
          key   => "HKEY_USERS\\${sid}\\${location_value}${name}",
          value => 'description',
          type  => 'string',
          data  => $description,
        }
      }
      # set allowsub folders
      if $allowsub {
        registry::value { "${sid}\\${location_value}${name}\\allowsubfolders":
          key   => "HKEY_USERS\\${sid}\\${location_value}${name}",
          value => 'allowsubfolders',
          type  => 'dword',
          data  => '1',
        }
      } else {
        registry::value { "${sid}\\${location_value}${name}\\allowsubfolders":
          key   => "HKEY_USERS\\${sid}\\${location_value}${name}",
          value => 'allowsubfolders',
          type  => 'dword',
          data  => '0',
        }
      }
    }
  }

}
