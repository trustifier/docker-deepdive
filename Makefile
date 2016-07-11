# Makefile for building and running a deepdive instance
#
# Copyright (C) 2016 Scott Phillpott <scott@ipptradecraft.com>
# Copyright (C) 2016 Ahmed Masud <ahmed.masud@trustifier.com>
# See LICENSE for usage details
#
# @@help main
#
# make help 	-- displays this help
#
# User mode:
#
# 	make		-- builds a docker image named <image-name>:latest
# 	make run	-- builds and runs a docker image named <image-name>:latest
#
# ** Note that in user mode all existing docker-deepdive images are removed 
#
# -----------------------------------------------------------------------------
# Developer mode (assumed if .git is present):
#
# 	make		-- build image from the current git branch
# 	make run 	-- build & run image from the current git branch
# 			   NOTE: the executed image gets deleted upon exit
#
# 	make latest	-- build image as latest from current git branch
# 	make run-latest	-- build & run image as latest from current git branch
#
# @@end-help

# @@help parameters
# 
# You can provide RUN, IMAGE and TAG as part of the build process:
#
# For example
#
# 	make TAG=3.5 (tag the image as 3.5)
# 	make IMAGE=foo TAG=bar (create image named 'foo' tagged as 'bar')
# 	make ROOT=<PATH | URL> (create image from path or URL instead of pwd)
#
# Use RUNAS to specify the instance name (defaults to docker-deepdive-instance)
#
# For example
#
# 	make run RUNAS=my-deepdive-instance
#
# @@end-help


ROOTDIR:=.
IMAGE:=docker-deepdive
TAG:=latest
RUNAS:=docker-deepdive-instance

####### do not edit below this #####

DOCKER=docker
MKDIR_P=mkdir -p
PERL=perl -w

# @@help verbosity
#
# Make flag increase make verbosity by setting V=1 
# For example, 
#
# 	make V=1 build
#
# @@end-help 

ifeq ($(V),)
Q=@
else
Q=
endif


# Suppress entering/leaving messages

.SILENT:

default:: build

help::
	$(Q)$(PERL) help.pl Makefile | $${PAGER:-less -XeF --prompt "Use j/k to scroll, quits at the end"}

maintainer-clean:: clean
	$(Q)$(RM) -r .deps 


build: 
	$(Q)$(DOCKER) build -t $(IMAGE):$(TAG) $(ROOTDIR)

run: build
	$(Q)$(DOCKER) run --rm -i -t --name $(RUNAS) $(IMAGE):$(TAG)

clean:


.deps:
	$(Q)$(MKDIR_P) $@

first-time-help:
	$(Q)test -f .deps/first-time-help || ($(MAKE) help && mkdir .deps && touch .deps/first-time-help)

.PHONY: all