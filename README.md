# CoreOS-Reflector

A _Hello World_ introduction to [CoreOS][0] and [Docker][1].

[coreos]:#todo
[docker]:#todo

## Getting Started

We're going to use Docker to run a cluster of CoreOS boxes and then start a client machine from which to run our service.

### Prequisites

You'll need both [Docker][1] and [Git][2] installed.

### Run the Service

1. Clone this repo:

  ```bash
  git clone git@github.com:pandastrike/coreos-reflector.git
  cd coreos-reflector
  ```

2. Start the CoreOS cluster with 3 machines:

  ```
  bin/start-cluster 3
  ```

3. Start the CoreOS client:

  ```
  bin/start-client
  ```

4. Shell into the client:

  ```
  docker exec -i client
  ```

5. Deploy the reflector service to the cluster:

  ```
  fleetctl --tunnel fleet.local start services/*.service
  ```

6. Monitor the deployment:

  ```
  fleetctl --tunnel fleet.local journal --follow=true services/*.service
  ```

7. You should see a message like this:

  > TODO: Ideally, we can echo the host/port here.

8. Test the echo service:

  ```
  telnet <host:port>
  Hello
  > Hello
  ```

[0]:#todo
[1]:#todo
[2]:#todo
[3]:#todo
[4]:#todo
