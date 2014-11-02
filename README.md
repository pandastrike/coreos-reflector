# CoreOS-Reflector

A _Hello World_ introduction to [CoreOS][0] and [Docker][1].

## Getting Started

We're going to use VirtualBox to run a cluster of CoreOS boxes.

### Prequisites

You'll need to install VirtualBox.

### Run the Service Locally

1. Clone this repo:

  ```bash
  git clone git@github.com:pandastrike/coreos-reflector.git
  cd coreos-reflector
  git checkout feature/virutalbox
  ```

2. Start the CoreOS machine:

  ```
  bin/cluster-up
  ```


3. Deploy the reflector service to the cluster:

  ```
  fleetctl --tunnel fleet.local start services/*.service
  ```

4. Monitor the deployment:

  ```
  fleetctl --tunnel fleet.local journal --follow=true services/*.service
  ```

5. You should see a message like this:

  > TODO: Ideally, we can echo the host/port here.

6. Test the echo service:

  ```
  telnet <host:port>
  Hello
  > Hello
  ```

To stop the service, simply run:

  ```
  bin/cluster-destroy
  ```

[0]:#todo
[1]:#todo
[2]:#todo
[3]:#todo
[4]:#todo

## Run On A Remote Cluster

To try this out on a remote cluster, just point to the Panda Strike CoreOS cluster standbox:

```
fleetctl -tunnel fleet.pandastrike.com start services/*.service
```

(You'll need a key from us to do this.)
