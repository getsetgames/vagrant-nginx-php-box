package { 'openssl':
  ensure => present,
}

$netdata = hiera_hash('netdata')

$ssl_root = '/vagrant'
$ssl_primary_hostname = $netdata[primary_name]
$ssl_primary_ip       = $netdata[primary_ip]

$vhost_hostname = 'test.getsetgames.com'
$www_root       = "/vagrant/www/${vhost_hostname}/"
$backend_port   = 9000

file { "${www_root}/${vhost_hostname}/inc-app.php":
  ensure  => present,
  content => template('/vagrant/templates/inc-app.php.erb')
}

file { "${www_root}/${vhost_hostname}/index.html":
  ensure  => present,
  content => template('/vagrant/templates/index.html.erb')
}

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

file { "${www_root}/${vhost_hostname}/server.crt":
  ensure  => present,
  source  => "${ssl_root}/${ssl_primary_hostname}.crt",

  require => Openssl::Certificate::X509[$ssl_primary_hostname]
}

class { 'nginx': }

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

 nginx::resource::location { "downloads_root":
   ensure          => present,
   ssl             => true,
   vhost           => "${vhost_hostname}",
   www_root        => "/downloads",
   location        => '~ \.ipa$',
   index_files     => ['index.html']
 }