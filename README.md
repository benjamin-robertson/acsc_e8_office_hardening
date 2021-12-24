# acsc_e8_office_hardening

Automate the enforcement of the ACSC essential eight Microsoft office macro security. 

The module will restrict the use of macro within Office. 

There are 4 operating modes
* All macros allowed - default mode
* All macros disabled - disabled all macros in Office, most secure setting
* Only macros from trusted locations - Only permit macros from locations specified in the trusted_location parameter
* Only macros digitally signed by trusted publishers.

Please see [ACSC documentation][1] for more details. 
[Saved link][2]

## Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with acsc_e8_office_hardening](#setup)
    * [What acsc_e8_office_hardening affects](#what-acsc_e8_office_hardening-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with acsc_e8_office_hardening](#beginning-with-acsc_e8_office_hardening)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

Use this module to automate the enforcement of ACSC Essential 8 Office macro controls. 

## Setup

### What acsc_e8_office_hardening affects

acsc_e8_office_hardening will add required registry settings to systems to restrict Office macros as required.

Most registry settings are applied to HKEY_USER. Due to this, Puppet will managed a significant number of resource as each user has its own registry hive. 
acsc_e8_office_hardening will also modify the default c:\users\Default\ntuser.dat. This is required for any new users who log on to the system. Without this, Puppet won't restrict that user until the next Puppet run. A suboptimal outcome. 
By default the module will mount and check the default ntuser.dat on each clean boot and every 24 hours thereafter. 

### Setup Requirements

Plugin sync is required for this module. Three facts will be automatically distributed
* local_sids
* office_macro_last_run
* office_macro_uptime

Following forge modules are required
* puppetlabs-stdlib
* puppetlabs-registry


### Beginning with acsc_e8_office_hardening

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most basic
use of the module.

## Usage

In most basic form, non-enforcement mode.

`include acsc_e8_office_hardening`

Block all macros

```
  class {'acsc_e8_office_hardening':
    macro_setting       => 'all_macros_disabled',
  }
```

Permit macros from trusted location using a profile and hiera

```
class profile::office_hardening (
  Hash $trusted_locations = {}
){
  class {'acsc_e8_office_hardening':
    macro_setting       => 'macros_from_trusted_locations'',
    trusted_locations   => $trusted_locations,
  }
}
```
Corresponding hiera data
```
profile::office_hardening::trusted_locations:
  location1:
    path: 'c:\\temp'
    date: '12/12/2021 12:00 PM'
    description: 'Temp on c for macros'
    allowsub: true
```

## Limitations

Supported office versions
- Office 365
- Office 2016
- Office 2019

Developed on
- Windows 2019
- Office 365

## Development

Please submit any issues to the issue tracker.
Pull requests keenly accepted :)

[1]: https://www.cyber.gov.au/acsc/view-all-content/publications/microsoft-office-macro-security
[2]: https://github.com/benjamin-robertson/acsc_e8_office_hardening/blob/main/PROTECT%20-%20Microsoft%20Office%20Macro%20Security%20(October%202021).pdf
[3]: https://puppet.com/docs/puppet/latest/puppet_strings_style.html
