class base::command {
  if ($facts['os']['distro']['id'] =~ "Debian") {

    exec { 'apt install -y python3':
      path   => '/usr/bin:/usr/sbin:/bin',
      unless => [ 'test -f /usr/bin/python3' ]
    }
  }
}
