class base::update {
  if ($facts['os']['distro']['id'] =~ "Debian") {
    exec { 'apt update -y' :
      path   => '/usr/bin:/usr/sbin:/bin',
    }
  }
  elsif ($facts['os']['family'] =~ "RedHat") {
    package { 'epel-release':
      ensure => present,
    } ->
    exec { 'yum update -y':
      path   => '/usr/bin:/usr/sbin:/bin',
    }
  }
}
