plan practise::glance (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
  $pkgs = lookup('pkgs', merge => 'unique', default_value => [])
  $glance_db_pass = lookup('glance_db_pass', default_value => [])
  $glance_pass = lookup('glance_pass', default_value => [])
  $ports = lookup('open_ports', default_value => [])

  if $facts['os']['family'] =~ "RedHat" {
    $pkgs.each | $pkg | {
      package { "${pkg}":
        name => $pkg,
        ensure => installed,
      }
    }
  }

  include 'mysql::client'
  include 'firewalld'

  $ports.each |$port| {
    firewalld_port { "${port}":
      ensure   => present,
      zone     => 'public',
      port     => $port,
      protocol => 'tcp',
    }
  }

  # setup authentication with keystone
  class { 'glance::api::authtoken':
    auth_url            => 'http://keystone:5000',
    password            => $glance_pass,
  } ->
  # db connection setup
  class { 'glance::api::db':
    database_connection => "mysql+pymysql://glance:$glance_db_pass@db/glance",
  } ->
  # main api setup
  class { 'glance::api':
    enabled_backends    => ['default_backend:file'],
    default_backend     => 'default_backend',
  }

  # db sync
  include 'glance::db::sync'

  # setup file storage backend
  glance::backend::multistore::file { 'default_backend': }

  }
  return $report
}
