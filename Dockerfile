FROM base/archlinux
MAINTAINER Dan Yoder (dan@pandastrike.com)

#===============================================================================
# CoreOS - Reflector Demo
#===============================================================================
# This Dockerfile is part of PandaStrike's tutorial repo for CoreOS + Docker.
# It is meant to demo deployment basics in a single-server example.  While this
# container is specified here for storage, in the app we pull the container from
# pandapup/coreos_reflector.

# We make use of the ArchLinux Docker image as a base and build from there.

# Install git. We use git to pull this example from its public repository into
# this Docker container.
RUN pacman -Syu --noconfirm git
RUN git clone https://github.com/pandastrike/coreos-reflector.git

# Install Node.  Modern Node comes with its own package manager, npm.
RUN pacman -Syu --noconfirm nodejs

# Install CoffeeScript globally and download any other packages specified by package.json
RUN npm install -g coffee-script
RUN cd coreos-reflector && npm install


#===============================================================================
# Launch the server
CMD cd coreos-reflector && coffee reflector.coffee
