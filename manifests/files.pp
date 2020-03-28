# == Define: mediawiki::files
#
# This defined type manages symbolic links to mediawiki configuration files.
# WARNING: Only for internal use!
#
# === Parameters
#
# [*target_dir*]    - mediawiki installation directory
#
# === Examples
#
#  mediawiki::files { $link_files:
#    target_dir => $target_dir,
# }
#
# === Authors
#
# Martin Dluhos <martin@gnu.org>
#
# === Copyright
#
# Copyright 2012 Martin Dluhos
#
define mediawiki::files (
  $target_dir
  ) {
  $root_group = $::mediawiki::params::root_group
  file { $name:
    ensure  => link,
    owner   => 'root',
    group   => $root_group,
    mode    => '0755',
    target  => gen_target_path($target_dir, $name),
  }
}
