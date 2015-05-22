class { 'nginx': }

$web_hostname = 'test.getsetgames.com'
$ssl_root = '/vagrant'
$www_root = "/vagrant/www/${web_hostname}/"
$backend_port = 9000

include ::php

nginx::resource::vhost { $web_hostname:
  ensure                => present,
  www_root              => "${www_root}",
  index_files           => [ 'index.php' ],

  ssl                   => true,
  ssl_cert              => "${ssl_root}/server.crt",
  ssl_key               => "${ssl_root}/server.key",

  require               => Service['php5-fpm']
}

nginx::resource::location { "${$web_hostname}_root":
   ensure          => present,
   ssl             => true,
   vhost           => "${web_hostname}",
   www_root        => "${www_root}",
   location        => '~ \.php$',
   index_files     => ['index.php'],
   proxy           => undef,
   fastcgi         => "127.0.0.1:${backend_port}",
   fastcgi_script  => undef,
   location_cfg_append => {
     fastcgi_connect_timeout => '3m',
     fastcgi_read_timeout    => '3m',
     fastcgi_send_timeout    => '3m'
   }
 }
