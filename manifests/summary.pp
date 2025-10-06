$_family = $facts['os']['family']
$_name = $facts['os']['name']
$_release = $facts['os']['release']['full']
$_distro = $facts['os']['distro']['codename']

file { "/tmp/summary.txt":
  ensure => 'present',
  mode => '0644',
  content => template('base/summary.erb'),
}
