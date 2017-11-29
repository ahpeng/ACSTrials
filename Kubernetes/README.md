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
    



    
