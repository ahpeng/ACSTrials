# Creating Kubenetes Cluster with GPU VM's on Azure for training Machine Learning Models

- 1) Complie acs-engine

    - Need to use [acs-engine](https://github.com/Azure/acs-engine) to create the cluster as ACS does not support GPU VM's as of now. Run these commands to build [acs-engine from source](https://github.com/Azure/acs-engine/blob/master/docs/acsengine.md) on Ubuntu with docker installed:

    `git clone https://github.com/Azure/acs-engine.git`

    `cd acs-engine`

    `./scripts/devenv.sh`

    `make bootstrap`

    `make build`

- 2) Deploy Cluster

    - Copy the `kubernetesgpu.json` to `examples` folder

    `./bin/acs-engine deploy --subscription-id <id> --dns-prefix jack --location westus2 --auto-suffix examples/kubernetesgpu.json`

    - This will generate all the artifacts including ARM templates inside `_outputs` folder and also deploy the ARM template to Azure.

- 3) Connect with the Cluster

    - Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

    - Download the `_output/<your-dns-name>/kubeconfig/kubeconfig.westus2.JSON` file.
        
        `chmod 777 _output -R`  (may needed to change permissions for download)

    - Set the `KUBECONFIG` environment variable

        `setx KUBECONFIG "<path>/kubeconfig.westus2.JSON"`  (for Windows)

    - Check if GPU Drivers are correctly installed

        `kubectl get nodes`

        `kubectl describe node <name of agent pool 1>`

        Check under `Capacity:`, `alpha.kubernetes.io/nvidia-gpu:  1`

- 4) Verify GPU support is working

    `kubectl create -f nvidia-smi.yaml`  (this would take some time)

    `kubectl get pods --show-all`  (to see the name of the pod with Status `Completed`)

    `kubectl logs <pod name>`

    ...


- Other Resources
    - https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/deploy.md
    - https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/gpu.md  


    
