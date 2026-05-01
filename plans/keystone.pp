plan practise::keystone (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
  $pkgs = lookup('pkgs', merge => 'unique', default_value => [])

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

  }
  return $report
}
