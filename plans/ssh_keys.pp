plan practise::ssh_keys (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
    $user = lookup('user', default_value => [])
    $keys = lookup('keys')

    file { "/home/$user/.ssh/authorized_keys":
      content => $keys.join("\n")
    }
  }
  # return $report
}
