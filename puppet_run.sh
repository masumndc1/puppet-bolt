#!/bin/bash

/opt/puppetlabs/bin/puppet apply manifests/site.pp --modulepath=./modules:.modules --hiera_config=hiera.yaml
