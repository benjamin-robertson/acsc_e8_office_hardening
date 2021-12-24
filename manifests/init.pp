# @summary
#
# A module which enforces https://www.cyber.gov.au/sites/default/files/2021-10/PROTECT%20-%20Hardening%20Microsoft%20365%2C%20Office%202021%2C%20Office%202019%20and%20Office%202016%20%28October%202021%29.pdf
#
#
# @example
#   include acsc_e8_office_hardening
#
# @param [Boolean] disable_flash_content
#   Disable flash content. Default: false
# @param [Boolean] disable_macros
#   Disable macros, Default: true
# @param [Integer] set_ntuser_interval
#   Set the interval to set the default ntuser macro settings in hours. Default: 1
# @param [Enum['all_macros_disabled','macros_from_trusted_locations','signed_macros_only','clear_macro_settings']] macro_setting
#   Macro settings to enforce, for details see ACSC publication. Default: clear_macro_settings
# @param [Variant[Undef,Hash[String,Hash,1,20]]] trusted_locations
#   Set trusted location. See example in readme. Default: undef
#
class acsc_e8_office_hardening (
  Boolean $disable_flash_content = false,
  Boolean $disable_macros = true,
  Integer $set_ntuser_interval = 24,
  Enum['all_macros_disabled','macros_from_trusted_locations','signed_macros_only','clear_macro_settings'] $macro_setting = 'clear_macro_settings', # lint:ignore:140chars
  Variant[Undef,Hash[String,Hash,1,20]] $trusted_locations = undef,
) {

  # Set run status
  registry::value { 'acsc_e8_office_hardening_last_run_option':
    key   => 'HKLM\\SOFTWARE\\Puppet Labs\\Puppet',
    value => 'office_macro_last_run',
    type  => 'string',
    data  => $macro_setting,
  }

  # Calculate offset for set_ntuser_interval
  $set_ntuser_int_seconds = $set_ntuser_interval * 3600
  $office_macro_uptime_plus_offset = $facts['office_macro_uptime'] + $set_ntuser_int_seconds

  # Check run count
  if $facts['office_macro_uptime'] > $facts['uptime_seconds'] {
    # we have rebooted
    registry::value { 'acsc_e8_office_hardening_uptime':
      key   => 'HKLM\\SOFTWARE\\Puppet Labs\\Puppet',
      value => 'office_macro_uptime',
      type  => 'dword',
      data  => $facts['uptime_seconds'],
    }
    $set_ntuser_default = true
  } elsif $facts['uptime_seconds'] > $office_macro_uptime_plus_offset {
    # we have passed the interval check ntuser.dat default
    registry::value { 'acsc_e8_office_hardening_uptime':
      key   => 'HKLM\\SOFTWARE\\Puppet Labs\\Puppet',
      value => 'office_macro_uptime',
      type  => 'dword',
      data  => $facts['uptime_seconds'],
    }
    $set_ntuser_default = true
  } elsif $facts['office_macro_uptime'] == 0 {
    # office_macro_uptime value has been deleted or unset
    registry::value { 'acsc_e8_office_hardening_uptime':
      key   => 'HKLM\\SOFTWARE\\Puppet Labs\\Puppet',
      value => 'office_macro_uptime',
      type  => 'dword',
      data  => $facts['uptime_seconds'],
    }
    $set_ntuser_default = true
  } else {
    $set_ntuser_default = false
  }

  # Mount user default registry hive
  include acsc_e8_office_hardening::mount_default_user_hive

  # Check if this is the first run of acsc_e8_office_hardening
  if $facts['office_macro_last_run'] != 'clear_macro_settings' {
    if $facts['office_macro_last_run'] != 'first_run' {
      # confirm we are not clearing macro all macro settings
      if $macro_setting != 'clear_macro_settings' {
        # this is not our first run check if the macro_setting has changed.
        if $facts['office_macro_last_run'] != $macro_setting {
          # Need to delete the non requried registry keys
          class { 'acsc_e8_office_hardening::clear_unused_registry_values':
            system_setting     => $facts['office_macro_last_run'],
            configured_setting => $macro_setting,
            require            => Class['acsc_e8_office_hardening::mount_default_user_hive'],
            before             => Class['acsc_e8_office_hardening::unmount_default_user_hive'],
          }
        }
      }
    }
  }

  if $disable_flash_content {
    include acsc_e8_office_hardening::disable_flash
  }

  if $disable_macros {
    class { 'acsc_e8_office_hardening::macros':
      macro_setting => $macro_setting,
      require       => Class['acsc_e8_office_hardening::mount_default_user_hive'],
      before        => Class['acsc_e8_office_hardening::unmount_default_user_hive'],
    }
  }

  if $macro_setting == 'macros_from_trusted_locations' {
    class { 'acsc_e8_office_hardening::trusted_locations':
      trusted_locations => $trusted_locations,
      require           => Class['acsc_e8_office_hardening::mount_default_user_hive'],
      before            => Class['acsc_e8_office_hardening::unmount_default_user_hive'],
    }
  }

  # Unmount user default registry hive
  include acsc_e8_office_hardening::unmount_default_user_hive

}
