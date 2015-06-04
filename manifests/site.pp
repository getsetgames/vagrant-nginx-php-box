package { 'openssl':
  ensure => present,
}

$netdata = hiera_hash('netdata')

$ssl_root = '/vagrant'
$ssl_primary_hostname = $netdata[primary_name]
$ssl_primary_ip       = $netdata[primary_ip]

openssl::certificate::x509 { $ssl_primary_hostname:
  ensure       => present,
  cnf_tpl      => '/vagrant/templates/cert.cnf.erb',
  country      => 'CA',
  organization => 'getsetgames.com',
  commonname   => $ssl_primary_ip,
  state        => 'ON',
  locality     => 'Toronto',
  unit         => 'Development',
  altnames     => [$ssl_primary_hostname], # only pass in the hostname
  base_dir     => $ssl_root,
  days         => 9999,
  
  require      => Package['openssl'],
}

class { 'nginx': }

$vhost_hostname = 'test.getsetgames.com'
$www_root = "/vagrant/www/${www_hostname}/"
$backend_port = 9000

include ::php

nginx::resource::vhost { $vhost_hostname:
  ensure                => present,
  www_root              => "${www_root}",
  index_files           => [ 'index.php' ],

  ssl                   => true,
  ssl_cert              => "${ssl_root}/${ssl_primary_hostname}.crt",
  ssl_key               => "${ssl_root}/${ssl_primary_hostname}.key",

  require               => [
    Service['php5-fpm'],
    Openssl::Certificate::X509[$ssl_primary_hostname]
  ]
}

nginx::resource::location { "${vhost_hostname}_root":
   ensure          => present,
   ssl             => true,
   vhost           => "${vhost_hostname}",
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
