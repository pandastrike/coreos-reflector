# CoreOS-Reflector

A _Hello World_ introduction to [CoreOS][0] and [Docker][1].

## Introduction

We're going to use PandaStrike's CoreOS test cluster, which we're running on Amazon's EC2 service for you, to deploy a simple Node server.  

Spinning up a CoreOS cluster is not the focus of this tutorial.  However, CoreOS provides a regularly updated, publicly available image of their OS, so building a cluster on Amazon (or any cloud provider) is painless.

## Prerequisites

You'll need:
- Our private key to access the test cluster
- SSH
- Telnet

## Deployment

1. The private key will be provided via the file `CoreOS-Reflector.pem`.  Use this with SSH to login.  You'll be logged into a fresh CoreOS machine, and it has everything you need to continue.  

  > TODO - Talk to Lance about setting up an address with DNS

  ```
  ssh -i CoreOS-Reflector.pem core@54.183.252.156
  ```

2. Clone this repo.

  ```
  git clone https://github.com/pandastrike/coreos-reflector.git
  cd coreos-reflector
  git checkout feature/ec2
  ```

3. Everything you need has been loaded by the repo, so all you need to do is call this script.

  ```
  bash scripts/service-start
  ```

4.  It will take a moment, but you will see a message indicating the Node server is ready.  From your local machine, you can then test the echo service.

  ```
  telnet <54.183.252.156:80>
  Hello
  > Hello
  ```

--------

You can stop the CoreOS logging with `ctrl+C`.  To stop the server, run:

  > TODO: Talk to Lance about rebooting to a fresh CoreOS machine on logout.

  ```
  bash scripts/service-stop
  ```

## Background
CoreOS is a lightweight OS that is built to work in a cluster.  It uses a distributed key-value store called etcd to communicate with other CoreOS machines.  Because it is so lightweight, CoreOS relies on Docker to load and run whatever application you ask it to deploy.

Because CoreOS is designed to cluster, it accepts jobs as a cluster.  Applications and their components are submitted as jobs to a system called fleet.  fleet ties together two technologies.  Working together, these allow fleet to be a control system that operates at the cluster level.  
- Individual machines use systemd and accept instructions via [unit-files][2].  
- Communication between machines is handled with [etcd][3], a key-value store that uses the Raft algorithm to achieve distributed consensus.

---
### service-start
If you examine the bash script `scripts/service-start`, you will see `fleetctl` is called to launch the reflector app.  `fleetctl` accepts "services" defined as unit-files. These lay out exactly what the CoreOS machine needs to call to spin-up your app.

---
### reflector.service
Take a look at `reflector.service`.  We keep it pretty simple for this example.  `[Unit]` just describes the service and lets fleetctl know what services need to be active before it can start this unit.  In this case, we need Docker to be active before we can do anything.

`[Service]` defines the actual guts of the unit.  There are two main types of commands here.

- `ExecStartPre` lists any commands that should occur before the service starts.  Here, we start downloading the Docker container that holds the Node server.  This command is convenient for handling tasks while the service is forced to queue for another unit.

- `ExecStart` list any commands that occur when the service is active.  Here, we run the Docker container.

This is just an introduction.  There are many other options in a unit-file, so please see the [documentation][2] for more.

---
### Dockerfile
The Docker container that gets called in `reflector.service` holds the simple Node server.  It is specified in `Dockerfile` for completeness, but the container has been uploaded to the public Docker registry.

The Node server is specified in `reflector.coffee`.  It is the *Hello World* equivalent of NodeJS.  It is  a one-line server that echoes whatever is sent to it.  

[0]:https://coreos.com/
[1]:https://docker.com/
[2]:https://coreos.com/docs/launching-containers/launching/fleet-unit-files/
[3]:https://coreos.com/docs/distributed-configuration/getting-started-with-etcd/
