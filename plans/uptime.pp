plan practise::uptime (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
    $_what_os = lookup('whatos')
    $uptime_msgs = $facts['system_uptime'].map |$type, $value| {
      "${value} ${type}"
    }

    notify { 'uptime_summary':
      message => "uptime : ${uptime_msgs} on ${$_what_os}"
    }
  }
  return $report
}
