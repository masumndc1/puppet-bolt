plan practise::ssh_keys (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
    $user = lookup('user', default_value => [])
    $keys = lookup('keys')

    package { 'sudo': ensure => installed, }

    file { "/etc/sudoers.d/10_${user}":
      content => "${user} ALL=(ALL:ALL) NOPASSWD: ALL",
      require => Package['sudo'],
      mode => '0440',
      validate_cmd => "sudo visudo -c",
    }

    file { "/home/$user/.ssh/authorized_keys":
      content => $keys.join("\n")
    }


  }
  # return $report
}
