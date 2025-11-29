plan practise::pkg (
  TargetSpec $nodes,
) {

  apply_prep($nodes)
  $report = apply($nodes) {
    if ($facts['os']['distro']['id'] =~ "Debian|Ubuntu") {
      apt::keyring { 'puppetlabs-keyring.gpg':
        source => 'https://apt.puppetlabs.com/keyring.gpg',
      }

      package { 'python3':
        ensure => installed,
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
  }
  return $report
}

