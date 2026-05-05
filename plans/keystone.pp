plan practise::keystone (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
  $pkgs = lookup('pkgs', merge => 'unique', default_value => [])
  $keystone_db_pass = lookup('keystone_db_pass', default_value => [])
  $admin_token = lookup('admin_token', default_value => [])
  $admin_pass = lookup('admin_pass', default_value => [])
  $email = lookup('admin_email', default_value => [])
  $ports = lookup('open_ports', default_value => [])
  $glance_pass = lookup('glance_pass', default_value => [])
  $cinder_pass = lookup('cinder_pass', default_value => [])
  $nova_pass = lookup('nova_pass', default_value => [])
  $neutron_pass = lookup('neutron_pass', default_value => [])

  if $facts['os']['family'] =~ "RedHat" {
    $pkgs.each | $pkg | {
      package { "${pkg}":
        name => $pkg,
        ensure => installed,
      }
    }
  }

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

  # db connection for keystone
  class { 'keystone::db':
    database_connection => "mysql+pymysql://keystone:${keystone_db_pass}@db/keystone",
  }

  class { 'keystone':
    catalog_driver => 'sql',
    # admin_token => "${admin_token}",
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
    password     => $admin_pass,
    email        => $email,
    project_name => 'admin',
    username     => 'admin',
    public_url   => 'http://keystone:5000',
    admin_url    => 'http://keystone:35357',
    internal_url => 'http://keystone:5000',
    region       => 'RegionOne',
  }

  # setup glance auth
  class { 'glance::keystone::auth':
    password     => $glance_pass,
    public_url   => 'http://glance:9292',
    admin_url    => 'http://glance:9292',
    internal_url => 'http://glance:9292',
    region       => 'RegionOne',
  }

  class { 'cinder::keystone::auth':
    password        => $cinder_pass,
    public_url_v3   => 'http://cinder:8776/v3',
    internal_url_v3 => 'http://cinder:8776/v3',
    admin_url_v3    => 'http://cinder:8776/v3',
    region          => 'RegionOne',
  }

  # rabbit
  class { 'rabbitmq':
    port              => 5672,
    # Recommended for security
    delete_guest_user => true,
    service_manage    => true,
    admin_enable => true,
  }

  # Create a user
  rabbitmq_user { 'rabbit':
    admin    => false,
    password => 'admin',
  }

  # Create a vhost
  rabbitmq_vhost { '/rabbit_vhost':
    ensure => present,
  }

  # Set permissions (configure, read, write)
  rabbitmq_user_permissions { 'rabbit@/rabbit_vhost':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  }


  }
  return $report
}
