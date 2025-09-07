class base {
  package { ['vim', 'curl']:
    ensure => installed,
  }
}
