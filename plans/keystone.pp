plan practise::keystone (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
  $pkgs = lookup('pkgs', merge => 'unique', default_value => [])
  $kstone_db_pass = lookup('keystone_db_pass', default_value => [])
  $admin_tkn = lookup('admin_token', default_value => [])
  $admin_pss = lookup('admin_pass', default_value => [])
  $email = lookup('admin_email', default_value => [])
  $ports = lookup('open_ports', default_value => [])

  if $facts['os']['family'] =~ "RedHat" {
    $pkgs.each | $pkg | {
      package { "${pkg}":
        name => $pkg,
        ensure => installed,
      }
    }
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

  # db connection for keystone
  class { 'keystone::db':
    database_connection => "mysql+pymysql://keystone:${kstone_db_pass}@db/keystone",
  }

  class { 'keystone':
    catalog_driver => 'sql',
    # admin_token => "${admin_tkn}",
    enabled => true,
    service_name => 'httpd',
  }

  # setup the keystone database schema
  # This runs 'keystone-manage db_sync'
  # class { 'keystone::db::sync': }

  # apache/WSGI front-end (standard for keystone)
  class { 'keystone::wsgi::apache':
    # set to true for production
    ssl => false,
  }

  # bootstrap the admin user and endpoints
  class { 'keystone::bootstrap':
    password     => $admin_pss,
    email        => $email,
    project_name => 'admin',
    username     => 'admin',
    public_url   => 'http://keystone:5000',
    admin_url    => 'http://keystone:35357',
    internal_url => 'http://keystone:5000',
    region       => 'RegionOne',
  }

  }
  return $report
}
