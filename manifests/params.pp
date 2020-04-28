# === Class: mediawiki::params
#
#  The mediawiki configuration settings idiosyncratic to different operating
#  systems.
#
# === Parameters
#
# None
#
# === Examples
#
# None
#
# === Authors
#
# Martin Dluhos <martin@gnu.org>
#
# === Copyright
#
# Copyright 2012 Martin Dluhos
#
class mediawiki::params {

  $major              = '1.33'
  $minor              = '0'
  $tarball_url        = "http://releases.wikimedia.org/mediawiki/$major/mediawiki-$major.$minor.tar.gz"
  $apache_daemon      = '/usr/sbin/apache2'
  $installation_files = ['api.php',
                         'api.php5',
                         'autoload.php',
			 'composer.json',
                         'docs',
                         'extensions',
                         'Gruntfile.js',
                         'img_auth.php',
                         'img_auth.php5',
                         'includes',
                         'index.php',
                         'index.php5',
                         'jsduck.json',
                         'languages',
                         'load.php',
                         'load.php5',
                         'maintenance',
                         'mw-config',
                         'opensearch_desc.php',
                         'opensearch_desc.php5',
                         'phpcs.xml',
                         'profileinfo.php',
                         'profileinfo.php5',
                         'Rakefile',
                         'resources',
                         'serialized',
                         'skins',
                         'StartProfiler.sample',
                         'tests',
                         'thumb_handler.php',
                         'thumb_handler.php5',
                         'thumb.php',
                         'thumb.php5',
                         'vendor',
                         'wiki.phtml']
  
  case $::operatingsystem {
    redhat, centos:  {
      $web_dir            = '/var/www/html'
      $doc_root           = "${web_dir}/wikis"
      $packages           = ['php74-php-gd', 'php74-php-mysql', 'php74-php-xml', 'php74-php-mbstring', 'wget', 'php74-php-pgsql']
      $root_group         = 'root'
      $wget_bin           = '/usr/bin/wget'
      $tar_bin            = '/bin/tar'
      $php_bin            = '/usr/bin/php'
      $conf_dir           = '/etc/mediawiki'
    }
    debian:  {
      $web_dir            = '/var/www'
      $doc_root           = "${web_dir}/wikis"
      $packages           = ['php', 'php-mysql', 'php-xml', 'php-mbstring', 'wget']
      $root_group         = 'root'
      $wget_bin           = '/usr/bin/wget'
      $tar_bin            = '/bin/tar'
      $php_bin            = '/usr/bin/php'
      $conf_dir           = '/etc/mediawiki'
    }
    ubuntu:  {
      $web_dir            = '/var/www'
      $doc_root           = "${web_dir}/wikis"
      $packages           = ['php5', 'php5-mysql', 'php-xml', 'php-mbstring', 'wget']
      $root_group         = 'root'
      $wget_bin           = '/usr/bin/wget'
      $tar_bin            = '/bin/tar'
      $php_bin            = '/usr/bin/php'
      $conf_dir           = '/etc/mediawiki'
    }
    freebsd:  {
      $web_dir            = '/usr/local/www'
      $doc_root           = "${web_dir}/wikis"
      $packages           = ['wget', 'php74-pdo_mysql', 'php74-gd', 'php74-pecl-imagick']
      $root_group         = 'wheel'
      $wget_bin           = '/usr/local/bin/wget'
      $tar_bin            = '/usr/bin/tar'
      $php_bin            = '/usr/local/bin/php'
      $conf_dir           = '/usr/local/etc/mediawiki'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
