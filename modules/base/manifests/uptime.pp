class base::uptime {
  $uptime_msgs = $facts['system_uptime'].map |$type, $value| {
    "${value} ${type}"
  }

  notify { 'uptime_summary':
    message => "uptime : ${uptime_msgs}"
  }
}
