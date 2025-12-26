#!/usr/bin/env python3

import sys
import subprocess

USER = "masum"
NODES = ["alma9", "deb12", "ubu22"]
LOC = " ~/Documents/github/puppet-bolt"


def cmds(node, num):
    user = USER
    loc = LOC
    cmd = (
        "rsync -avz -progress"
        + loc
        + " -e 'ssh -F ssh.config'"
        + " {}@sys-{}-dev{}:~".format(user, node, num)
    )

    subprocess.call(cmd, shell=True)


def main():
    if len(sys.argv) == 2:
        num = sys.argv[1]
    else:
        print("python3 rsync_push.py 3")
        sys.exit()

    for node in NODES:
        print("\n" + node)
        cmds(node, num)


if __name__ == "__main__":
    main()
