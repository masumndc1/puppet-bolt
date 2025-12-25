class base::ssh_keys (
  $user = lookup('user', default_value => []),
  $keys = lookup('keys')
) inherits base {
  file { "/home/$user/.ssh/authorized_keys":
     content => $keys.join("\n")
  }
}
