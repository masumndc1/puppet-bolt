class base::pkg (
  $pkgs = lookup('pkgs', { merge => 'unique'})
) {

  if ($facts['os']['distro']['id'] =~ "Debian|Ubuntu") {
    apt::keyring { 'puppetlabs-keyring.gpg':
      source => 'https://apt.puppetlabs.com/keyring.gpg',
    }

    $pkgs.each | $pkg | {
      package { $pkg:
        ensure => present,
      }
    }
  }

  elsif ($facts['os']['family'] =~ "RedHat") {

    $pkgs.each | $pkg | {
      package { $pkg:
        ensure => present,
      }
    }
  }
}
