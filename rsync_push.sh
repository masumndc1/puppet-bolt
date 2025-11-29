#!/bin/bash

rsync -avz -progress ~/Documents/github/puppet-bolt -e "ssh -F ssh.config" masum@sys-deb12-dev"$1":/home/masum/
rsync -avz -progress ~/Documents/github/puppet-bolt -e "ssh -F ssh.config" masum@sys-alma9-dev"$1":/home/masum/
rsync -avz -progress ~/Documents/github/puppet-bolt -e "ssh -F ssh.config" masum@sys-ubu22-dev"$1":/home/masum/
