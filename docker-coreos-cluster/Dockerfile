FROM base/archlinux
MAINTAINER Dan Yoder (dan@pandastrike.com)

#===============================================================================
# CoreOS - Reflector Demo
#===============================================================================
# This Dockerfile is part of PandaStrike's tutorial repo for CoreOS + Docker.
# Here, we setup a CoreOS cluster on top of the ArchLinux base image.

# When installed in the cloud, CoreOS takes over the machine when you install it
# to disk. Running CoreOS locally requires us to simulate the hardware, which
# this Docker container cannot do alone.  We turn to the virtual machine
# platform, Vagrant.  We install it here.
RUN pacman -Syu --noconfirm vagrant

# Next, we need the orchestration tools CoreOS uses, fleetctl.
# The source-code for fleet is in a publically available GitHub repo.
# Install git to retrieve it.
RUN pacman -Syu --noconfirm git

# fleet's binary executable is built using Google's Go. Install Go.
RUN pacman -Syu --noconfirm go

# Now install fleet.
RUN git clone https://github.com/coreos/fleet.git
RUN cd fleet && ./build


# We need to gather the config files for Vagrant.  They are located in a directory
# of this project's repository.  Clone the repository here.
RUN git clone https://github.com/pandastrike/coreos-reflector.git

# The container is ready.
# Shell into this container and call the following command:
# bash coreos-reflector/bin/build-cluster <number-of-machines-in-cluster>
