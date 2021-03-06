# Class: mediawiki::install
#
# This class installs mediawiki
# that needs to be performed exactly once and is therefore not mediawiki
# instance specific.
#
# === Parameters
#
# [*server_name*]      - the host name of the server
# [*admin_email*]      - email address Apache will display when rendering error page
# [*db_root_password*] - password for mysql root user
# [*doc_root*]         - the DocumentRoot directory used by Apache
# [*tarball_url*]      - the url to fetch the mediawiki tar archive
# [*package_ensure*]   - state of the package
# [*max_memory*]       - a memcached memory limit
#
# === Examples
#
# class { 'mediawiki':
#   server_name      => 'www.example.com',
#   admin_email      => 'admin@puppetlabs.com',
#   db_root_password => 'really_really_long_password',
#   max_memory       => '1024'
# }
#
# mediawiki::instance { 'my_wiki1':
#   db_name          => 'wiki1_user',
#   db_password      => 'really_long_password',
# }
#
## === Authors
#
# Martin Dluhos <martin@gnu.org>
# Seth Tunstall <seth@tunstall.in>
#
# === Copyright
#
# Copyright 2012 Martin Dluhos
# Copyright 2018 Seth Tunstall
#
class mediawiki::install (
  $doc_root       = $mediawiki::params::doc_root,
  $tarball_url    = $mediawiki::params::tarball_url,
  $package_ensure = 'latest',
  $max_memory     = '2048'
  ) inherits mediawiki::params {

  # SELinux Booleans
  selinux::boolean { 'httpd_use_sasl': }
  selinux::boolean { 'httpd_can_connect_ldap': }
  selinux::boolean { 'httpd_can_sendmail': }
  selinux::boolean { 'httpd_can_network_connect_db': }


  $web_dir = $mediawiki::params::web_dir

  # Parse the url
  $tarball_dir              = regsubst($tarball_url, '^.*?/(\d\.\d+).*$', '\1')
  $tarball_name             = regsubst($tarball_url, '^.*?/(mediawiki-\d\.\d+.*tar\.gz)$', '\1')
  $mediawiki_dir            = regsubst($tarball_url, '^.*?/(mediawiki-\d\.\d+\.\d+).*$', '\1')
  $mediawiki_install_path   = "${web_dir}/${mediawiki_dir}"
  
  # Specify dependencies
  # TODO: Do the DB installation first
  # TODO: Drop logo file in place
  # TODO: Either put 'TLS_REQCERT     never' in /etc/openldap/ldap.conf
  # or do proper CA cert distribution (won't happen in a self-signed cert env.)

  #  ensure_resource('package', $mediawiki::params::packages, {
  #    ensure  => $package_ensure,
  #  })
  package { $mediawiki::params::packages:
    ensure => $package_ensure
  }

  # Make sure the directories and files common for all instances are included
  file { 'mediawiki_conf_dir':
    ensure  => 'directory',
    path    => $mediawiki::params::conf_dir,
    owner   => 'root',
    group   => $root_group,
    mode    => '0755',
    require => Package[$mediawiki::params::packages],
  }  
  
  # Download and install MediaWiki from a tarball
  exec { "get-mediawiki":
    cwd       => $web_dir,
    command   => "${wget_bin} ${tarball_url}",
    creates   => "${web_dir}/${tarball_name}",
    subscribe => File['mediawiki_conf_dir'],
  }
    
  exec { "unpack-mediawiki":
    cwd       => $web_dir,
    command   => "${tar_bin} -xvzf ${tarball_name}",
    creates   => $mediawiki_install_path,
    subscribe => Exec['get-mediawiki'],
  }
  
  class { 'memcached':
    max_memory => $max_memory,
    max_connections => 1024,
  }
} 
