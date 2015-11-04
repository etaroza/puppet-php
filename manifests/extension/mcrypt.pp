# Installs the mcrypt extension for a specific version of php.
#
# Usage:
#
#     php::extension::mcrypt { 'mcrypt for 5.4.10':
#       php => '5.4.10'
#     }
#
define php::extension::mcrypt(
  $php,
) {
  require php::config

  # Get full patch version of PHP
  $patch_php_version = php_get_patch_version($php)

  # Require php version eg. php::5_4_10
  # This will compile, install and set up config dirs if not present
  php_require($patch_php_version)

  $extension = 'mcrypt'

  # Final module install path
  $module_path = "${php::config::root}/versions/${patch_php_version}/modules/${extension}.so"

  # Additional options
  $configure_params = "--with-mcrypt=${boxen::config::homebrewdir}/opt/mcrypt"

  php_extension { $name:
    provider         => php_source,

    extension        => $extension,

    homebrew_path    => $boxen::config::homebrewdir,
    phpenv_root      => $php::config::root,
    php_version      => $patch_php_version,

    configure_params => $configure_params,
  }

  # Add config file once extension is installed

  file { "${php::config::configdir}/${patch_php_version}/conf.d/${extension}.ini":
    content => template('php/extensions/generic.ini.erb'),
    require => Php_extension[$name],
  }

}
