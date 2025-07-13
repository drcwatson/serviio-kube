# docker-serviio

[![](http://serviio.org/images/serviio.png)](http://serviio.org/) 

Link on github: [drcwatson/serviio-kube](https://github.com/drcwatson/serviio-kube)

Build on [soerentsch/docker-serviio](https://github.com/soerentsch/docker-serviio) to add Kubernetes support.

This is an **extremely** simple Helm setup for Serviio on Kubernetes.
Basically it supports my own cluster - which is RaspPi based and with an NFS server for persistent storage.  MetalLB is used to provide IP addresses.

The media is mounted from a seperate NAS over NFS; each of the video/audio/still endpoints are mounted separately.

## Comoponents

### PVC

A single NFS PVC to hold the library.

### Deployment

This is a simple deployment with 1 replica.

/mnt/serviio/media is mounted from the NAS - this holds just video in this version.

/opt/serviio/library is mounted from the PVC

### Services

#### DLNA

The DLNA has to be configured as a NodePort, with the pod set to run on the hostNetwork:

```
hostNetwok: true
```

See (https://www.jamesmoriarty.xyz/post/kubernetes-and-dlna/) - although I first got it from a Stackoverflow post that I cannot now find and cannot credit.

#### REST

The REST endpoints are exposed using a seperate service and are standard LoadBalancers exposed through Metallb.

The console is available on http://<IP>/console.

## Pulling Images from GitHub Container Registry (ghcr.io)

To deploy this chart using images from GitHub Container Registry, you need to create a Personal Access Token (PAT) and a Kubernetes image pull secret:

### 1. Create a GitHub Personal Access Token (PAT)

1. Go to [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens).
2. Click "Generate new token" (classic).
3. Give it a name and select the `read:packages` scope and `repo`
4. Copy the token and save it securely.

### 2. Create the Kubernetes Secret

Replace `<username>` and `<PAT>` with your GitHub username and the token you created:

```sh
kubectl create secret docker-registry ghcr \
  --docker-server=ghcr.io \
  --docker-username=<username> \
  --docker-password=<PAT> \
  --docker-email=<your-email>
```
