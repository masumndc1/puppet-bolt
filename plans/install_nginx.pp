plan practise::install_nginx (
     TargetSpec $targets,
     String $site_content = 'hello!',
   ) {

     # Install the puppet-agent package if Puppet is not detected.
     # Copy over custom facts from the Bolt modulepath.
     # Run the `facter` command line tool to gather target information.
     $targets.apply_prep

     # Compile the manifest block into a catalog
     apply($targets) {
       if($facts['os']['family'] == 'redhat') {
         package { 'epel-release':
           ensure => present,
           before => Package['nginx'],
          }
         $html_dir = '/usr/share/nginx/html'
       } else {
         $html_dir = '/var/www/html'
       }

       package {'nginx':
         ensure => present,
       }

       file {"/var/www/index.html":
         content => $site_content,
         ensure  => file,
       }

       service {'nginx':
         ensure  => 'running',
         enable  => 'true',
         require => Package['nginx']
       }
     }
   }
