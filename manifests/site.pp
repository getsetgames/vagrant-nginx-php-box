class { 'nginx': }

$web_hostname = 'test.getsetgames.com'
$ssl_root = '/vagrant'

nginx::resource::vhost { $web_hostname:
  ensure              => present,
  www_root            => "/vagrant/www/${web_hostname}/",
  index_files           => [ 'index.html' ],

  ssl                   => true,
  ssl_cert              => "${ssl_root}/server.crt",
  ssl_key               => "${ssl_root}/server.key",
}
