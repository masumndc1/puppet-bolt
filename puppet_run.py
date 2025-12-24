#!/usr/bin/env python3

import os
import sys
import subprocess


def cmd_run(cmd):
    cmds = (
        cmd
        + " apply manifests/site.pp"
        + " --modulepath=./modules:.modules"
        + " --hiera_config=hiera.yaml"
    )
    subprocess.call(cmds, shell=True)


def main():
    if os.path.exists("/opt/puppetlabs/bin/puppet"):
        cmd = "/opt/puppetlabs/bin/puppet"
    elif os.path.exists("/usr/bin/puppet"):
        cmd = "/usr/bin/puppet"
    else:
        print("we only support redhat and debian based OS")
        sys.exit()

    cmd_run(cmd)


if __name__ == "__main__":
    main()
