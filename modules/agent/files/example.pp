$hostname = $facts['networking']['hostname']
notice ( "Running on host: ${hostname}" )

#notify { 'This is a notification message':
#  message => 'Apache has been installed!',
#}
