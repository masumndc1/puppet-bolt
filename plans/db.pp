plan practise::db (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {

  # lookups here
  $kstone_db_pass = lookup('keystone_db_pass', default_value => [])
  $glance_db_pass = lookup('glance_db_pass', default_value => [])

  include 'firewalld'

  # add mysql service to firewalld
  firewalld_service { 'mysql':
    ensure  => present,
    service => 'mysql',
    zone    => 'public',
  }

  include 'mysql::client'

  # set mysql server to listen to connection coming from outside
  class { 'mysql::server':
    override_options => {
      'mysqld' => {
        'bind-address' => '0.0.0.0',
      },
    },
  }

  # define the mysql database for keystone
  mysql::db { 'keystone':
    user     => 'keystone',
    password => "${kstone_db_pass}",
    host     => 'localhost',
    grant    => ['ALL'],
    charset  => 'utf8',
    collate  => 'utf8_general_ci',
  }

  # define the mysql database for glance
  mysql::db { 'glance':
    user     => 'glance',
    password => "${glance_db_pass}",
    host     => '%',
    grant    => ['ALL'],
    charset  => 'utf8',
    collate  => 'utf8_general_ci',
  }

  }
  return $report
}
