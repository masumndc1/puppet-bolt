class infra::summary (
  $_hostname = $facts['hostname'],
  $_arch = $facts['os']['architecture'],
  $_uptime = $facts['system_uptime']['uptime'],
  $_family = $facts['os']['family'],
  $_name = $facts['os']['name'],
  $_release = $facts['os']['release']['full'],
  $_distro = $facts['os']['distro']['codename']
) {
  file { '/home/root/summary.txt':
    content => template('infra/summary.erb')
  }
}
