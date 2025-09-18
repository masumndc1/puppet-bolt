if ($facts['os']['distro']['id'] =~ "Debian|Ubuntu") {
  apt::keyring { 'puppetlabs-keyring.gpg':
    source => 'https://apt.puppetlabs.com/keyring.gpg',
  }
}

if ($facts['os']['distro']['release']['major'] in ['8','9','10']) {
  # https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
  # https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
  # https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
  $source = "https://dl.fedoraproject.org/pub/epel/epel-release-latest-${facts['os']['distro']['release']['major']}.noarch.rpm"

  yum::install { 'epel-release':
    ensure => present,
    source => $source,
  }
}
