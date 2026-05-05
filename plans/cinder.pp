plan practise::cinder (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
  $pkgs = lookup('pkgs', merge => 'unique', default_value => [])
  $cinder_db_pass = lookup('cinder_db_pass', default_value => [])
  $cinder_pass = lookup('cinder_pass', default_value => [])
  $rabbit_pass = lookup('rabbit_pass', default_value => [])
  $ports = lookup('open_ports', default_value => [])

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


  # main api setup
  class { 'cinder::db':
     database_connection => "mysql+pymysql://cinder:$cinder_db_pass@db/cinder",
  } ->
  class { 'cinder::keystone::authtoken':
    password             => $cinder_pass,
    auth_url             => 'http://keystone:5000',
    www_authenticate_uri => 'http://keystone:5000',
    memcached_servers    => ["keystone:11211"],
  }

  # call cinder class
  class { 'cinder':
     default_transport_url  => "rabbit://rabbit:${rabbit_pass}@keystone:5672/rabbit_vhost",
  }

  # api service
  class { 'cinder::api':
    enabled => true,
  }

  # scheduler service
  class { 'cinder::scheduler':
    enabled => true,
  }

  # volume service and backend (example: LVM)
  # this sets up the 'cinder-volume' service
  class { 'cinder::volume':
    enabled => true,
  }

  # define the specific LVM backend
  cinder::backend::nfs { 'zfs_backend':
    # IP of the storage node
    nfs_servers => ['127.0.0.1:/cinder-pool/volumes'],
    nfs_mount_options => 'rw,sync,no_root_squash',
  }

  # tell Cinder which backends to use
  class { 'cinder::backends':
    enabled_backends => ['zfs_backend'],
  }


  }
  return $report
}
