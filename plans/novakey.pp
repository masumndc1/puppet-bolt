plan practise::novakey (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
  $pkgs = lookup('pkgs', merge => 'unique', default_value => [])
  $ports = lookup('open_ports', default_value => [])
  $nova_pass = lookup('nova_pass', default_value => [])
  $nova_db_pass = lookup('nova_db_pass', default_value => [])
  $placement_pass = lookup('placement_pass', default_value => [])

  if $facts['os']['family'] =~ "RedHat" {
    class { 'selinux':
      mode => 'disabled',
    }
  }

  if $facts['os']['family'] =~ "RedHat" {
    $pkgs.each | $pkg | {
      package { "${pkg}":
        name => $pkg,
        ensure => installed,
      }
    } }

  # enable crb repo
  yumrepo { 'crb':
    enabled => 1,
  }


  # define all lookup here
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

  class { 'nova::keystone::auth':
    password         => $nova_pass,
    auth_name        => 'nova',
    service_name     => 'nova',
    public_url       => 'http://nova:8774',
    internal_url     => 'http://nova:8774',
    admin_url        => 'http://nova:8774',
    region           => 'RegionOne',
    configure_endpoint => true,
    configure_user     => true,
  }

  class { 'nova::placement':
    auth_url => 'http://keystone:5000',
    password => $placement_pass,
  }

  class { 'nova::keystone::authtoken':
    password             => $nova_pass,
    auth_url             => 'http://keystone:5000',
    www_authenticate_uri => 'http://keystone:5000',
  }

  class { 'nova::db':
    database_connection   => "mysql+pymysql://nova:${nova_db_pass}@db/nova",
    api_database_connection   => "mysql+pymysql://nova:${nova_db_pass}@db/nova_api",
  }

  class { 'nova::api':
    enabled           => true,
  }
  class { 'nova::scheduler': }
  class { 'nova::conductor': }


  }
  return $report
}
