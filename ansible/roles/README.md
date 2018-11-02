## Overview

In order of execution:

`common`
- installs base utilities used on all machines
- configures the timezone

`dotfiles`
- adds custom bashrc and vimrc files (for demonstration/utility purposes)

`netplan`
- replaces the [cloud-init](https://launchpad.net/cloud-init)-provided netplan configuration
	- we opted to replace the configuration instead of using a module to make it idempotent

`consul`
- installs Consul and its service configuration

`consul-server`
- configures the Consul agent to create a Consul "raft"; a cluster of Consul servers

`consul-client`
- configures the Consul agent to connect to the existing Consul "raft"

`go`
- installs Go, used to install the remaining tools

`webapp`
- installs the [demo web application](https://github.com/adrialu/consul-web-demo)

`fabio`
- installs the [Fabio](https://fabiolb.net/) web proxy application, connecting it to Consul

## Contents

Brief description of the subfolders in every "role":

`tasks`
- describes what should be done to complete this role

`handlers`
- describes task-like operations that will only be used when called upon from an _actual_ task
	- e.g. only restart a service if the configuration has changed

`templates`
- pre-populated (and optionally dynamic) configuration templates used in tasks
