plan practise::uptime (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {
    $uptime_msgs = $facts['system_uptime'].map |$type, $value| {
      "${value} ${type}"
    }

    notify { 'uptime_summary':
      message => "uptime : ${uptime_msgs}"
    }
  }
  return $report
}
