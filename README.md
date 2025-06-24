#  puppet-bolt
practise of puppet bolt

# bolt inventory

```bash
❯ cat inventory.yaml
groups:
  - name: ubu-lxd
    targets:
      - 192.168.244.146
    config:
      transport: ssh
      ssh:
        user: masum
        run-as: root
        private-key: ~/.ssh/id_rsa
        host-key-check: false
        batch-mode: false
        connect-timeout: 30

```

# bolt plan

```bash

❯ bolt plan show
Plans
  aggregate::count                    Run a task, command, or script on targets and aggregate the results...
  aggregate::targets                  Run a task, command, or script on targets and aggregate the results...
  canary                              Run a task, command or script on canary targets before running it on...
  extended_stdlib::csr_regenerate     This plan modifies the CSR attributes on servers, and then regenerates...
  facts                               A plan that retrieves facts and stores in the inventory for...
  facts::external                     A plan that generates external facts based on the provided modulepath...
  facts::info                         A plan that prints basic OS information for the specified targets. It...
  practise::install_apache            Install and start Apache
  practise::install_nginx
  practise::run_cmd                   run a pp file
  puppet_agent::run                   Starts a Puppet agent run on the specified targets.
  puppet_connect::test_input_data     Tests that the provided Puppet Connect input data is complete, meaning...
  puppetdb_fact                       Collect facts for the specified targets from PuppetDB and store...
  reboot                              Reboots targets and waits for them to be available again.
  secure_env_vars                     Run a command or script with sensitive environment variables.
  terraform::apply
  terraform::destroy
  terraform::refresh

Modulepath
  /Users/khuddin/Documents/github/puppet-bolt/modules:/Users/khuddin/Documents/github/puppet-bolt/.modules

Additional information
  Use 'bolt plan show <PLAN NAME>' to view details and parameters for a specific plan.


❯ bolt plan run -v practise::install_apache -t ubu-lxd
Starting: plan practise::install_apache
Starting: task package on 192.168.244.146
Started on 192.168.244.146...
Finished on 192.168.244.146:
  {
    "status": "installed",
    "version": "2.4.58-1ubuntu8.6"
  }
Finished: task package with 0 failures in 2.39 sec
Starting: task service on 192.168.244.146
Started on 192.168.244.146...
Finished on 192.168.244.146:
  {
    "status": "MainPID=1394,LoadState=loaded,ActiveState=active"
  }
Finished: task service with 0 failures in 0.81 sec
Starting: task service on 192.168.244.146
Started on 192.168.244.146...
Finished on 192.168.244.146:
  {
    "status": "MainPID=1394,LoadState=loaded,ActiveState=active",
    "enabled": "enabled"
  }
Finished: task service with 0 failures in 1.41 sec
Finished: plan practise::install_apache in 4.63 sec
Plan completed successfully with no result

```

# get remote facts

```bash

❯ bolt task run facts -i inventory.yaml --target ubu-lxd

Started on 192.168.244.146...
Finished on 192.168.244.146:
  {
    "lsbdistrelease": "24.04",
    "lsbmajdistrelease": "24.04",
    "os": {
      "release": {
        "full": "24.04",
        "major": "24.04"
      },
      "distro": {
        "release": {
          "full": "24.04",
          "major": "24.04"
        },
        "codename": "noble",
        "description": "Ubuntu 24.04 LTS",
        "id": "Ubuntu"
      },
      "architecture": "aarch64",
      "name": "Ubuntu",
      "family": "Debian",
      "hardware": "aarch64",
      "selinux": {
        "enabled": false

```

# bolt command run

```bash
❯ bolt -i inventory.yaml command run 'pwd' --targets ubu-lxd
Started on 192.168.244.146...
Finished on 192.168.244.146:
  /root
Successful on 1 target: 192.168.244.146
Ran on 1 target in 0.77 sec

```

# failed command

```bash

❯ bolt plan run -v practise::run_cmd -t ubu-lxd
Starting: plan practise::run_cmd
Starting: install puppet and gather facts on 192.168.244.146
Finished: plan practise::run_cmd in 2.49 sec
Failed on 192.168.244.146:
  The task failed with exit code 127 and no stdout, but stderr contained:
  sh: 1: /tmp/7c97a035-dead-4a86-b16c-1fe064b8c395/custom_facts.rb: not found
Failed on 1 target: 192.168.244.146
Ran on 1 target

❯ bolt apply -e example.pp -i inventory.yaml -t ubu-lxd
Starting: install puppet and gather facts on 192.168.244.146
Finished: install puppet and gather facts with 1 failure in 2.56 sec
Starting: apply catalog on
Finished: apply catalog with 0 failures in 0.0 sec
Failed on 1 target: 192.168.244.146
Ran on 1 target in 2.7 sec

```


[!NOTE]
> This is work in progress.
> No assurance that all examples will works.
