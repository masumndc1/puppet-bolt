plan practise::pkg (
  TargetSpec $nodes,
) {

  apply_prep($nodes)
  $report = apply($nodes) {
    $pkgs = lookup('py_pkgs')
    if ($facts['os']['distro']['id'] =~ "Debian|Ubuntu") {
      apt::keyring { 'puppetlabs-keyring.gpg':
        source => 'https://apt.puppetlabs.com/keyring.gpg',
        mode => '0644'
      }
    }

    # RHEL-family 8/9/10
    elsif $facts['os']['family'] =~ "RedHat" {
      $os_major = $facts['os']['release']['major']
      $source = "https://dl.fedoraproject.org/pub/epel/epel-release-latest-${os_major}.noarch.rpm"

      yum::install { 'epel-release':
        ensure => present,
        source  => $source,
      }
    }

    $pkgs.each | $pkg | {
      package { "$pkg":
        name => $pkg,
        ensure => installed,
      }
    }
  }
  return $report
}
