# openshift-apache-php

Template for running a apache php on a container based on alpine linux/openshift/docker.

### Installation

You need oc (https://github.com/openshift/origin/releases) localy installed:

create a new project

```sh
oc new-project openshift-apache-php \
    --description="WebServer - Apache PHP" \
    --display-name="Alpine Apache PHP"
```

Clone the repository
```sh
git clone https://github.com/ure/openshift-apache-php.git
cd openshift-apache-php
```

Create the BuildConfig and DeploymentConfig

```sh
oc create -f BuildConfig.yaml
oc create -f DeploymentConfig.yaml
```

Deploy

```sh
oc new-app https://github.com/ure/openshift-alpine-apache-php.git
```

#### Route.yml

Create routes for sites to be proxied

```sh
oc create -f Route.yaml
```
