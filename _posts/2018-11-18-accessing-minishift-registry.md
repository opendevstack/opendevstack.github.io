---
title: "Accessing minishift registry from Linux"
topics:
  - OpenShift
author: richard.attermeyer
---
In the [Getting Started](https://opendevstack.org/doc/getting-started.html) guide,
we provide instructions on how to setup OpenDevStack on a Windows host.
This blog post explores one aspect: accessing the configured docker registry from a Linux Host.
It might also be helpful, if you have Rundeck not running on OpenShift.

## Assumptions

We assume, that you have set up OpenShift as described in the getting started guide and that you
have exposed a route to the minishift internal registry.

## Extract the minishift CA certificate

On your linux host, execute

`openssl s_client -connect 192.168.99.100:8443 -showcerts < /dev/null 2>/dev/null| sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /tmp/minishift.crt`

You should now have two PEM encoded certificate in /tmp/minishift.crt.
Remove the first one (this is the server certificate) and keep the CA Cert using the editor of your choice.

## Make docker recognize the new CA

Docker will recognize all ca certificates that are stored under `/etc/docker/certs.d` in a [special directory structure](https://docs.docker.com/engine/security/certificates/#understanding-the-configuration).

So, we need to set this structure up:

`mkdir -p /etc/docker/certs.d/docker-registry-default.192.168.99.100.nip.io`

and copy the CA cert there:

`cp /tmp/minishift.crt /etc/docker/certs.d/docker-registry-default.192.168.99.100.nip.io`

## Login and test

*On Windows*, you can get a login token, using `oc login -u developer -n default && oc whoami -t`.
This token, you will need to login to the docker registry.

So, on your *Linux* box, execute:

`docker login -u developer -p "<token-value>" docker-registry-default.192.168.99.100.nip.io`

You should now see a "Login succeeded".

Try now to pull your `cd/jenkins-slave-base` image.

`docker pull docker-registry-default.192.168.99.100.nip.io/cd/jenkins-slave-base`
