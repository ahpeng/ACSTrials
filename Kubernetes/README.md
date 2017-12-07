# Introduction to Kubernetes

## Running Minikube locally

- https://kubernetes.io/docs/getting-started-guides/minikube/

## Installing Minikube on Windows

- Install VirtualBox
- Download the [minikube-windows-amd64.exe](https://storage.googleapis.com/minikube/releases/latest/minikube-windows-amd64.exe) file, rename it to minikube.exe and add it to your path.
- Download [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-via-curl) and add it to your PATH 

- Start minikube

    `minikube start --vm-driver=virtualbox`

    `minikube status`

    `kubectl cluster-info`

    `minikube stop`


## Installing Minikube on Windows 10 with Hyper-V

- Create new Virtual Switch in Hyper-V as [shown here](https://blogs.msdn.microsoft.com/wasimbloch/2017/01/23/setting-up-kubernetes-on-windows10-laptop-with-minikube/)

    `minikube start --help`

    `minikube start --kubernetes-version="v1.8.0" --vm-driver="hyperv" --memory=1024 --hyperv-virtual-switch="My k8s Virtual Switch" --v=7 --alsologtostderr`

    `minikube status`

    `minikube dashboard`

## kubectl

- Get Cluster Info

    `kubectl cluster-info`

- Get API List

    `kubectl proxy`

    Browse `http://localhost:8001/` to see the list of API's

- Access API using token

    `kubectl describe secret`   (copy the token)

    `kubectl config view`       (copy the cluster url)

    Try the cluster url with `Authorization : Bearer <token>`

- Get Pods Details

    `kubectl get pods -o wide`

    `export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')`

    `echo Name of the Pod: $POD_NAME`

    `curl http://localhost:8001/api/v1/proxy/namespaces/default/pods/$POD_NAME/`

    `kubectl logs $POD_NAME`

    `kubectl exec $POD_NAME env`

    `kubectl exec -ti $POD_NAME bash`

- Get Service Details

    `export NODE_PORT=$(kubectl get services/<service name> -o go-template='{{(index .spec.ports 0).nodePort}}')`

    `echo NODE_PORT=$NODE_PORT`




## Deploy simple Application

- Using Dashoard UI

    `minikube dashboard`

    create new app name = `webserver`, image = `nginx:alpine`, pods = `3`

- Using CLI

    `kubectl create -f webserver.yaml`

- Verify

    `kubectl get deployments`

    `kubectl get replicasets`

    `kubectl get pods`

    `kubectl describe pod webserver-78b68cf8d9-jxqff`

    `kubectl get pods -L app,label2`  (add additional 2 columns app, label2 to the output)

    `kubectl get pods -l app=webserver`   (filter pods by labels)

    `kubectl delete deployments webserver` 

- Using `NodePort` ServiceType

    `kubectl create -f webserver.yaml`

    `kubectl create -f webserver-svc.yaml`

    `kubectl get service`

    `kubectl describe svc web-service`   (copy the NodePort)
    
    (`web-service` uses `app=webserver` as a Selector, so it selected the 3 Pods created by `webserver.yaml`, which are listed as `Endpoints` here. So, when we send a request to our Service, it will be served by one of the Pods listed in the Endpoints section)

    `minikube ip`  (get local IP)

- Browse the Service

    `http://<local IP>:<NodePort>`
    

## Using `hostPath` Volume Type

- Create a volume folder on the host

    `minikube ssh`

    `mkdir -p jomitvolume`

    `cd jomitvolume`

    `echo "Testing Volumes" > index.html`

    `pwd`   (copy the path)

- Create deployments

    `kubectl create -f webserver-volumes.yaml`

    `kubectl create -f webserver-svc.yaml`

- Browse the Service using the local IP and NodePort as done before. (we should see our custom index.html content.)

    `http://<minikube local IP>:<NodePort>`


## Deploying Muti-tier Application

- Source code for the sample app is available [here](https://github.com/cloudyuga/rsvpapp)

- Deploy Database

    `cd RSVPApp`

    `kubectl create -f db.yaml`

    `kubectl create -f db-service.yaml`

    `kubectl get deployments`
    `kubectl get services`

- Deploy Frontend

    `kubectl create -f web.yaml`

    `kubectl create -f web-service.yaml`

    `kubectl get deployments`
    `kubectl get services`

- Browse the frontend using the local IP and NodePort as done before. (we should see our custom index.html content.)

    `http://<minikube local IP>:<NodePort>`

- Scaling the Frontend

    `kubectl scale --replicas=4 -f web.yaml`

    `kubectl get deployments`

    Browse the frontend to see the `Service from Host` value change depending on which replica is serving the request.


## Perform Rolling update for an app

- `kubectl get deployments`

- `kubectl describe pods`  (to see current image version)

- `kubectl set image deployments/<deployment name> <deployment name>=<new docker image>`

    Example : `kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2`

- `kubectl get pods`  (see the pods terminating and updating the new image)

- `kubectl describe pods`  (verify new version of the image)

- `kubectl rollout status deployments/<deployment name>`  (see the rollout status)

- `kubectl rollout undo deployments/<deployment name>`  (undo rollout if there is an error)



## ConfigMaps

- Create using literal values

    `kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2`

    `kubectl get configmaps my-config -o yaml`

- Create using file

    `kubectl create -f customer1-configmap.yaml`

    `kubectl describe configmap customer1`

- Use inside Pods as Environment Variables (see [documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#adding-configmap-data-to-a-volume) for more details)

    see `RSVPApp\web-configmap.yaml`


## Secrets

- Create a new secret using command line

    `echo 'mypassword' > password.txt`

    `tr -Ccsu '\n' < password.txt > .strippedpassword.txt && mv .strippedpassword.txt password.txt` (Remove trailing new lines from the file)

    `kubectl create secret generic my-password --from-file=password.txt`

    `kubectl get secret my-password`

    `kubectl describe secret my-password`

- Create a new secret manually using yaml  (Please note that it uses base64 encoding which can easily decoded so do not checkin the .yaml file in source code if you are using this approach)

    see `secret.yaml` 

- See [documentation](https://kubernetes.io/docs/concepts/configuration/secret/#using-secrets) to use secrets as files from pod or as environment variables.


## Ingress (Ingresscontroller is a layer 7 load balancer)

- Create sample Blue/Green services

    `cd BlueGreenApps`

    `minikube ssh`

    `mkdir blueapp`

    `mkdir greenapp`

    `echo "<h1 style='color:blue'>This is BLUE App<h1>" > blueapp/index.html`

    `echo "<h1 style='color:green'>This is GREEN App<h1>" > greenapp/index.html`

    `kubectl create -f webapp-blue.yaml`

    `kubectl create -f webapp-green.yaml`

    `kubectl create -f webservice-blue.yaml`

    `kubectl create -f webservice-green.yaml`

- Configure ingress controller on minikube

    `minikube addons enable ingress`

    Update the `hosts` file to point to our minikube ip and the host name provided in the `web-ingress.yaml` file

    `kubectl create -f web-ingress.yaml`

    `kubectl get ingress`

    `kubectl describe ingress blue-green-ingress`

## Annotations

- To add extra metadata in key/value pairs to an object. See [documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) for more details


## Deployment Features

- Deployment object provides features like rollback, autoscaling, proportional scaling, pausing & resuming. See [documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#scaling-a-deployment) for more details.

## Jobs

- Create pods to perform a task and automatically terminates them once the task is over. See [documentation](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/#what-is-a-job) for more details.

- We can also create [cron jobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/).

## Quota Management

- [ResourceQuota](https://kubernetes.io/docs/concepts/policy/resource-quotas/) object can be used to control resource consumption per Namespace.

- Types of quotas include : Compute Resource Quota, Storage Resource Quota and Object Count Quota

## DaemonSets

- A special object that allow to create a specific type of Pod which runs on all nodes all the time. 

- Can be used for collecting monitoring data from all nodes or running a storage daemon on all nodes etc. See [documentation](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) for more details.

## StatefulSets

- StatefulSet controller is used to manage stateful applications that require unique identity, strict ordering. See [documentation](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) for more details.

## Role Based Access Control (RBAC)

- RBAC API can be used to define roles, permissions for a Namespace or Cluster and then bind to users. See [documentation](https://kubernetes.io/docs/admin/authorization/rbac/) for more details.

## Kubernetes Federation

- [Kubernetes Cluster Federation](https://kubernetes.io/docs/concepts/cluster-administration/federation/) can help manage multiple Kubernetes clusters from a single control plane. 
- It also helps sync resources across multiple clusters with cross cluster discovery. This allows enables deployments across regions.

## Third Party Resources (Objects) / Custom Resource Definition (CRD)

- Create custom API objects and controllers. [ThirdPartyResource](https://kubernetes.io/docs/tasks/access-kubernetes-api/extend-api-third-party-resource/) is deprecated as of Kubernetes 1.7 and has been removed in version 1.8
- For version 1.8 you need to use Custom Resource Definition. See details [here](https://kubernetes.io/docs/tasks/access-kubernetes-api/migrate-third-party-resource/)


## Helm

- Package manager for Kubernetes. Helps install/update/delete Charts (type of Bundle) in the Kubernetes cluster. See [documentation](https://github.com/kubernetes/helm) for more details.

- The client helm connects to the server tiller to manage Charts. Charts submitted for Kubernetes are available [here](https://github.com/kubernetes/charts).


## Monitoring and Logging

- [Heapster](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/) is a cluster-wide aggregator of monitoring and event data and is natively supported on Kubernetes. 

- [Prometheus](https://prometheus.io/), now part of [CNCF](https://www.cncf.io/) (Cloud Native Computing Foundation), can also be used to scrape the resource usage from different Kubernetes components and objects. It also has client libraries whic can be used to instrument the application code.

- For Logging the most common way to collect the logs is using [Elasticsearch](https://kubernetes.io/docs/tasks/debug-application-cluster/logging-elasticsearch-kibana/), which uses [fluentd](http://www.fluentd.org/) with custom configuration as an agent on the nodes. fluentd is an open source data collector, which is also part of CNCF.








