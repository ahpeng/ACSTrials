# Running Minikube locally

- https://kubernetes.io/docs/getting-started-guides/minikube/

# Installing Minikube on Windows

- Install VirtualBox
- Download the [minikube-windows-amd64.exe](https://storage.googleapis.com/minikube/releases/latest/minikube-windows-amd64.exe) file, rename it to minikube.exe and add it to your path.
- Download [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-via-curl) and add it to your PATH 

- Start minikube

    `minikube start --vm-driver=virtualbox`

    `minikube status`

    `kubectl cluster-info`

    `minikube stop`


# Installing Minikube on Windows 10 with Hyper-V

- Create new Virtual Switch in Hyper-V as [shown here](https://blogs.msdn.microsoft.com/wasimbloch/2017/01/23/setting-up-kubernetes-on-windows10-laptop-with-minikube/)

    `minikube start --help`

    `minikube start --kubernetes-version="v1.8.0" --vm-driver="hyperv" --memory=1024 --hyperv-virtual-switch="My k8s Virtual Switch" --v=7 --alsologtostderr`

    `minikube status`

    `minikube dashboard`

# kubectl

- Get Cluster Info

    `kubectl cluster-info`

- Get API List

    `kubectl proxy`

    Browse `http://localhost:8001/` to see the list of API's

- Access API using token

    `kubectl describe secret`   (copy the token)

    `kubectl config view`       (copy the cluster url)

    Try the cluster url with `Authorization : Bearer <token>`


# Deploy simple Application

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

    `kubectl describe svc web-service`   (get NodePort)
    
    (`web-service` uses `app=webserver` as a Selector, so it selected the 3 Pods created by `webserver.yaml`, which are listed as `Endpoints` here. So, when we send a request to our Service, it will be served by one of the Pods listed in the Endpoints section)

    `minikube ip`  (get local IP)

- Browse the Service

    `http://<local IP>:<NodePort>`
    

# Using `hostPath` Volume Type

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

    `http://<local IP>:<NodePort>`


