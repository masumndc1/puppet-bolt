plan practise::summary (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $result = apply($nodes) {
    $_hostname = $facts['networking']['hostname']
    $_family = $facts['os']['family']
    $_name = $facts['os']['name']
    $_release = $facts['os']['release']['full']
    $_distro = $facts['os']['name']
    $_arch = $facts['os']['architecture']

    file { "/tmp/summary.txt":
      ensure => 'present',
      mode => '0644',
      content => template('base/summary.erb'),
    }
  }
  return $result
}
