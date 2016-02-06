# openshift-apache-php

Template for running a apache php on a container based on alpine linux/openshift/docker.

### Installation

You need oc (https://github.com/openshift/origin/releases) localy installed:

create a new project (change to your whishes)

```sh
oc new-project openshift-apache-php \
    --description="WebServer - Apache PHP" \
    --display-name="Apache PHP"
```

Deploy

```sh
oc new-app https://github.com/ure/openshift-apache-php.git -n php-webserver
```

#### Route.yml

Create routes for sites to be proxied

```sh
curl https://raw.githubusercontent.com/ure/openshift-apache-php/master/Route.yaml | oc create -f -
```
