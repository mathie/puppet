# Rubaidh's Puppet Cluster

This is the Puppet configuration I was using between 2012 and 2015 for
Rubaidh's own infrastructure, and for several client projects. It was able to
bootstrap an entire simulation of the Puppet environment (including a local
puppet master, and ancillary bits) inside your local development environment,
using Vagrant and VirtualBox. It was also able to bootstrap and deploy entirely
self-contained environments (including, but not limited to, your production
environment) on Rackspace Cloud, or Amazon Web Services. The provisioning and
bootstrapping code was modular enough that it should have been straightforward
to deploy to other kinds of cloud infrastructure, too.

Judging by the emails I'm still filtering out of my inbox, at least one cluster
is still chugging away, running this code! That said, it probably requires a
bit of work to bring it up to date -- the fiddly bit is that it still relied on
Ruby 1.8.7 to run Puppet, which was a good idea at the time, but that needs
brining into the early 21st century.

I was always quite pleased with this work. In particular, the ability to run an
entire simulated environment on my laptop, bootstrapped from scratch, felt
pretty good. Maybe there's some stuff in here that can inspire you to build
something better? The way the firewalling is implemented is quite neat, I
think, in that I've inverted the dependencies, so a client being configured to
access a service generates the corresponding firewall on the service to open
access to that client. There's a similar pattern for nginx reverse proxying for
backend apps. I got quite into using exported resources!

If nothing else, it's perhaps a good blueprint for the basic *stuff* that a
newly bootstrapped server ought to have done to it before it's unleashed on the
Internet. It's a conversation around that which caused me to dig this repo out,
and remind myself of what I did.

(I'm trying quite hard not to write code for my current project, never mind run
services, so I'm not in the mood for digging into this much further right now.
Perhaps some day I'll review it and write an article or two...)
