# Public: specify the global php version for phpenv
#
# Usage:
#
#   class { 'php::global': version => '5.4.10' }
#
class php::global($version = undef) {
  include php::config

  # Get full patch version of PHP
  $patch_php_version = php_get_patch_version($version)

  if $patch_php_version != 'system' {
    php_require($patch_php_version)
  }

  file { "${php::config::root}/version":
    ensure  => present,
    owner   => $::boxen_user,
    mode    => '0644',
    content => "${patch_php_version}\n",
  }
}
