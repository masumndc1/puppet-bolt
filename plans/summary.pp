plan practise::summary (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $result = apply($nodes) {
    $_family = $facts['os']['family']
    $_name = $facts['os']['name']
    $_release = $facts['os']['release']['full']
    $_distro = $facts['os']['distro']['codename']

    file { "/tmp/summary.txt":
      ensure => 'present',
      mode => '0644',
      content => template('base/summary.erb'),
    }
  }
  return $result
}
