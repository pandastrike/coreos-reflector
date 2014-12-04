# CoreOS-Reflector + Githook

A _Hello World_ introduction to maintaining [CoreOS][0] services with [githooks][1].

## Introduction

We're going to use a hook-server (see below) PandaStrike has in place to activate our CoreOS test cluster with githooks.  Githooks are special scripts residing in the `.git` directory of every repo.  They execute at varying times, as designated by their filenames.

We are interested in the githook `post-receive`.  It is a server-side githook triggered by a a `git push` command,  so we can use it for continuous integration, updating the CoreOS cluster automatically.  For reasons explained [here](https://github.com/pandastrike/PandaHook/blob/master/README.md#comparison-to-gitreceive), we will use PandaHook to manage our githooks on a remote, centralized server we call a hook-server.  

Manually launching services on a CoreOS cluster is not the focus of this tutorial. That more fundamental information is located in the main ReadMe.

## Prerequisites

You'll need:

1. To coordinate with us to get your **public key** into our hook-server and cluster for SSH access.

2. Your **userID**, a value ranging from 00 to 99

3. **git**. Please clone this repo.

4. The githook management tool, [PandaHook](https://github.com/pandastrike/PandaHook).
    ```shell
    npm install -g pandahook
    ```

5. The configuration dotfile, `.pandahook.cson`.  It stores reusable configuration data and is placed into the `$HOME` directory (ie, `~/.pandahook.cson`)
    ```coffee
    # Required Hook-Server Stanza
    hookServer:
      address: "git@hook.pandastrike.com"

    # Optional Stanza for CoreOS.
    coreos:
      address: "core@coreos.pandastrike.com"
    ```

6. Setup agent-forwarding on your SSH client.  Edit `~/.ssh/config` to include the following.
    ```
    Host hook.pandastrike.com
      ForwardAgent yes
    ```

## Deployment
1. You should be ready to get your hands dirty!  The PandaHook commands will be shown below, but the tool will also provide information for just about every command when followed by "help".

  Create the `post-receive` script using PandaHook's handy generator.  These can be created or edited manually, but basic functions will be added to the generator tool.
  ```
  pandahook build coreos post-receive restart coreos-reflector reflector@02
  ```

  There is now a file named `post-receive` in your local directory.  Review it and you can see that it makes the necessary fleetctl calls to restart the specified service(s) on the CoreOS cluster.


2.  Place this script into the hook-server.

    ```
    pandahook push coreos-reflector post-receive
    ```

3. Push the git repository to the hook-server.  The `pandahook push` command placed an alias for the hook-server into git for you, under "hook".

    ```shell
    git add --all
    git commit -m "I Did Stuff."
    git push hook master
    ```

    You should see a git push to the hook-server, followed by the script executing.  Any changes you made are now online in the CoreOS cluster (unless there is a delay to pull a Docker container).  

    From now on, any changes to this repo can be deployed via step 3).  Magic!!

    Step 3) output will look something like this:

    ```
    Counting objects: 7, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (4/4), done.
    Writing objects: 100% (4/4), 1.70 KiB | 0 bytes/s, done.
    Total 4 (delta 1), reused 0 (delta 0)
    remote:
    remote: ===================================
    remote: Push Detected. Activating Githook.
    remote: ===================================
    remote:
    remote: -----------
    remote: Cloning Bare Repo
    remote: -----------
    remote: Cloning into 'coreos-reflector'...
    remote: done.
    remote:
    remote: -----------
    remote: Stopping Service(s)
    remote: -----------
    remote: Destroyed reflector@02.service
    remote:
    remote: -----------
    remote: Restarting Service: CoreOS Reflector Demo
    remote: -----------
    remote: Unit reflector@02.service launched on aab181eb.../10.252.5.233
    To git@hook.pandastrike.com:coreos-reflector
        11d7ab5..5c5a3b1  master -> master
    ```


[0]:https://www.docker.com/
[1]:http://git-scm.com/docs/githooks
