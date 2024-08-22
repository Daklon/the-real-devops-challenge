# Description
This directory contains all required files to test the given solution.

Inside the kind directory is the kind configuration required to test it.

The traefik directory has the values needed by the traefik chart. It must be installed inside the kind cluster.

The webserver directory contains the requested chart. This chart will create a deployment a service and an ingress listening at the 127.0.0.1.nip.io (which translate to 127.0.0.1)

# Commands to install it
## create kind cluster
```bash
kind create cluster --config kind/cluster.yaml
```
## install traefik
```bash
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install --create-namespace --namespace=traefik -f traefik/values.yaml traefik traefik/traefik
```
## install the webserver chart
```bash
helm install webserver webserver/ -f webserver/values.yaml --namespace webserver --create-namespace
```
# Test it
To check if everything is working correctly check the http://127.0.0.1.nip.io address using your browser or curl. It must return an "Hello, world" to any given path
