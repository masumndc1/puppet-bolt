plan practise::nova (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
  $pkgs = lookup('pkgs', merge => 'unique', default_value => [])
  $nova_db_pass = lookup('nova_db_pass', default_value => [])
  $nova_pass = lookup('nova_pass', default_value => [])
  $neutron_pass = lookup('neutron_pass', default_value => [])
  $placement_pass = lookup('placement_pass', default_value => [])
  $rabbit_pass = lookup('rabbit_pass', default_value => [])
  $ports = lookup('open_ports', default_value => [])
  $keystone_ip = lookup('keystone_ip', default_value => [])

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

  class { 'nova::compute':
    enabled                      => true,
    manage_service               => true,
    vnc_enabled                  => true,
    instance_usage_audit         => true,
    instance_usage_audit_period  => 'hour',
  }

  # identity authentication for Nova to talk to Keystone
  class { 'nova::keystone::authtoken':
    password             => $nova_pass,
    auth_url             => 'http://keystone:5000',
    www_authenticate_uri => 'http://keystone:5000',
  }

  class { 'nova::placement':
    password             => $placement_pass,
    auth_url             => 'http://keystone:5000',
  }

  class { 'nova::db':
    database_connection     => "mysql+pymysql://nova:${nova_db_pass}@db/nova",
    api_database_connection => "mysql+pymysql://nova:${nova_db_pass}@db/nova_api",
  }

  class { 'nova':
    my_ip                 => $facts['networking']['ip'],
    default_transport_url => "rabbit://rabbit:${rabbit_pass}@keystone-alma9-dev9:5672/",
    notification_driver   => 'messagingv2',
    rabbit_ha_queues      => false,
    amqp_durable_queues   => false,
  }

  nova_config {
    'oslo_messaging_rabbit/rabbit_address_family': value => 'ipv4';
  }

  class { 'nova::compute::libvirt':
    # virt_type => 'kvm',
    virt_type   => 'qemu',
    cpu_mode    => 'none',
  }

  class { 'nova::network::neutron':
    password => $neutron_pass,
    auth_url => 'http://keystone:5000',
  }

  }
  return $report
}
