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
* 

### Beginning with acsc_e8_office_hardening

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most basic
use of the module.

## Usage

Include usage examples for common use cases in the **Usage** section. Show your
users how to use your module to solve problems, and be sure to include code
examples. Include three to five examples of the most important or common tasks a
user can accomplish with your module. Show users how to accomplish more complex
tasks that involve different types, classes, and functions working in tandem.

## Reference

This section is deprecated. Instead, add reference information to your code as
Puppet Strings comments, and then use Strings to generate a REFERENCE.md in your
module. For details on how to add code comments and generate documentation with
Strings, see the [Puppet Strings documentation][2] and [style guide][3].

If you aren't ready to use Strings yet, manually create a REFERENCE.md in the
root of your module directory and list out each of your module's classes,
defined types, facts, functions, Puppet tasks, task plans, and resource types
and providers, along with the parameters for each.

For each element (class, defined type, function, and so on), list:

* The data type, if applicable.
* A description of what the element does.
* Valid values, if the data type doesn't make it obvious.
* Default value, if any.

For example:

```
### `pet::cat`

#### Parameters

##### `meow`

Enables vocalization in your cat. Valid options: 'string'.

Default: 'medium-loud'.
```

## Limitations

- Will only work with
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
