class base::greet {
  include base::uptime
  $hostname = $facts['networking']['hostname']
  notice("Running on host: ${hostname}")
  notify { 'This is a notification message':
    message => 'hows your day',
  }
}
