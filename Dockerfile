FROM base/archlinux
MAINTAINER Dan Yoder (dan@pandastrike.com)
#===============================================================================
# CoreOS - Reflector Demo
#===============================================================================
# This Dockerfile part of the CoreOS-Reflector sample project. It is meant to demo
# deployment basics in a single-server example.  We make use of the Arch Linux
# Docker image as a base and build from there.

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
