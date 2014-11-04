# CoreOS-Reflector

A _Hello World_ introduction to [CoreOS][0] and [Docker][1].

## Introduction

We're going to use PandaStrike's CoreOS test cluster, which we're running on Amazon's EC2 service for you, to deploy a simple Node server.  

Spinning up a CoreOS cluster is not the focus of this tutorial.  However, CoreOS provides a regularly updated, publicly available image of their OS, so building a cluster on Amazon (or any cloud provider) is relatively painless.

## Prerequisites

You'll need:

1. Our **private key** to access the test cluster

2. The orchestration tool, **fleetctl**.  This is available via your OS package manager.

OSX users with HomeBrew can use:

    brew install fleetctl

Ubuntu users can use:

    apt-get install fleetctl


## Deployment

1. The private key will be provided to you via the file `ec2-pandastrike-id_rsa`.  Add this private key as an identity to your SSH authentication agent.  This grants you remote access to our CoreOS cluster via fleetctl's SSH based tools (More on that later).  

  ```
  chmod 400 ec2-pandastrike-id_rsa
  ssh-add ec2-pandastrike-id_rsa
  > Identity added: ec2-pandastrike-id_rsa (ec2-pandastrike-id_rsa)
  ```

  Test that your setup is configured properly by running:
  ```
  fleetctl --tunnel coreos.pandastrike.com list-machines
  ```
  If everything is working, this will produce a list of every CoreOS machine in our cluster, and will look something like this.
  ```
  > MACHINE		IP		        METADATA
  > 05cd8495...	10.229.64.167	 -
  > 50b58f24...	10.250.163.185	-
  > c0171bc5...	10.228.6.17	   -
  ```

2. Clone this repo to your local machine.

  ```
  git clone https://github.com/pandastrike/coreos-reflector.git
  cd coreos-reflector
  ```

3. Now, we will use fleetctl's `start` command. CoreOS relies on `*.service` files to specify jobs for the cluster (See *Background* for more information).  To access the cluster from your local machine, we need to use the `--tunnel <address>` flag, which will make use of SSH for you.  

  With this flag, you only need to type the specific fleetctl command and the service it applies to.

  ```
  fleetctl --tunnel coreos.pandastrike.com start reflector.service
  > Unit reflector.service launched on 05cd8495.../10.229.64.167
  ```

4. Now we are going to monitor your deployment with fleetctl's `journal` command.  Your job has been deployed on the CoreOS cluster, but where is it? Even though it could be on any one of several machines, you can always reference this job through its `*.service` file.

  ```
  fleetctl --tunnel coreos.pandastrike.com journal --follow=true reflector.service
  ```
  It might take a moment, but you will see a message indicating the Node server is ready.  You should also see a message listing the Public IP Address of the CoreOS machine running your server.  You'll need this for the next step.
  ```
  Starting CoreOS Reflector Demo...
  ======================================
  New Service Started
  ======================================
  Public IP Address: 184.72.26.40
  Pulling repository pandapup/coreos_reflector
  Started CoreOS Reflector Demo.
  =================================================
  The server is online and listening on Port 80.
  =================================================
  ```

5. We are ready to test the Node server from your local machine.  Open a new terminal.  Using the `telnet` command-line tool, connect to the IP Address you noted above, port 80.  Send a message, and you should see it sent right back to you.

  ```
  telnet 184.72.26.40 80
  > Trying 184.72.26.40...
  > Connected to ec2-184-72-26-40.us-west-1.compute.amazonaws.com.
  > Escape character is '^]'.

  Pandas Are Awesome.
  > Pandas Are Awesome.
  ```
  Say it with me:  **Pandas Are Awesome.**  Congratulations, you have successfully completed your first cloud deployment with CoreOS!

## Shutdown
You can stop the CoreOS journaling with `ctrl+C`.

  We also have to be considerate and release cluster resources when we are done.  To release the CoreOS machine running our job, we use the `stop` command and reference the service name.

  ```
  fleetctl --tunnel coreos.pandastrike.com stop reflector.service
  > Unit reflector.service loaded on 05cd8495.../10.229.64.167
  ```

  To remove the service from the cluster's pool we must use the `destroy` command.
  ```
  fleetctl --tunnel coreos.pandastrike.com destroy reflector.service
  > Destroyed reflector.service
  ```
  **Note: This command is also important if we edit our `*.service` file locally and want to give the cluster the new version.  We must destroy the old version first.**

--------


## Background
CoreOS is an operating system so lightweight that it relies on Docker to load and run whatever application you ask it to deploy.  CoreOS machines are designed to connect and bear a workload as a cluster.  Applications and their components are submitted as jobs to a control system called fleet.  By tying two technologies together, fleet is able to sit at the cluster level, accept your commands, and orchestrate efforts accordingly.
- Individual machines use the established tool, systemd, and accept instructions via [unit-files][2].  
- Communication between machines is handled with [etcd][3], a key-value store that uses the Raft algorithm to achieve distributed consensus.

---
### fleetctl
If you examine the deployment instructions, you will see `fleetctl` (pronounced "fleet control") is called to launch the reflector app.  `fleetctl` is a command-line tool that is part of the larger software package, fleet.  fleetctl accepts "services" defined as unit-files. These lay out exactly what the CoreOS machine needs to call to spin-up your app, similar to a shell script.

---
### reflector.service
Take a look at `reflector.service`.  We keep it pretty simple for this example.  

`[Unit]` just describes the service and lets fleetctl know what services need to be active before it can start this unit.  In this case, we need Docker to be active before we can do anything.

`[Service]` defines the actual guts of the unit.  There are two main types of commands here.

- `ExecStartPre` lists any commands that should occur before the service starts.  Here, we start downloading the Docker container that holds the Node server.  This command is convenient for handling tasks while the service is forced to queue for another unit.

- `ExecStart` list any commands that occur when the service is active.  Here, we run the Docker container.

This is just an introduction.  There are many other options in a unit-file, so please see the [documentation][2] for more.

---
### Dockerfile
The Docker container that gets called in `reflector.service` holds the simple Node server.  It is specified in `Dockerfile` for completeness, but the container has been uploaded to the public Docker registry.

The Node server is specified in `reflector.coffee`.  It is the *Hello World* equivalent of NodeJS, a one-line server that echoes whatever is sent to it.  

[0]:https://coreos.com/
[1]:https://docker.com/
[2]:https://coreos.com/docs/launching-containers/launching/fleet-unit-files/
[3]:https://coreos.com/docs/distributed-configuration/getting-started-with-etcd/
