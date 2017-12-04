# Creating Kubenetes Cluster with GPU VM's on Azure for training Machine Learning Models

## Compile acs-engine

- Need to use [acs-engine](https://github.com/Azure/acs-engine) to create the cluster as ACS does not support GPU VM's as of now. Run these commands to build [acs-engine from source](https://github.com/Azure/acs-engine/blob/master/docs/acsengine.md) on Ubuntu with docker installed:

- `git clone https://github.com/Azure/acs-engine.git`
- `cd acs-engine`
- `./scripts/devenv.sh`
- `make bootstrap`
- `make build`

## Deploy Cluster

- Copy the `kubernetesgpu.json` to `examples` folder

- `./bin/acs-engine deploy --subscription-id <id> --resource-group jomitk8s --dns-prefix jomitk8s --location westus2 --api-model examples/kubernetesgpu.json`

- This will generate all the artifacts including ARM templates inside `_outputs` folder and also deploy the ARM template to Azure.

## Connect with the Cluster

- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

- Download the `_output/<your-dns-name>/kubeconfig/kubeconfig.westus2.JSON` file.
        
    - `chmod 777 _output -R`  (may needed to change permissions for download)

- Set the `KUBECONFIG` environment variable

    - `setx KUBECONFIG "<path>/kubeconfig.westus2.JSON"`  (for Windows)

- Check if GPU Drivers are correctly installed

    - `kubectl get nodes`

    - `kubectl describe node <name of agent pool 1>`

    - Check under `Capacity:`, `alpha.kubernetes.io/nvidia-gpu:  1`

- Open Dashboard

    - `kubectl proxy` and then browse the `<url provided>/ui`

## Verify GPU support is working using `nvidia/cuba` image

- `kubectl create -f nvidia-smi.yaml`  (this would take some time)

- `kubectl get pods --show-all`  (to see the name of the pod with Status `Completed`)

- `kubectl logs <pod name>`  (this should print out a table which shows NVIDIA-SMI output with K80 or M60)

## ML Model training (using exiting docker image)

- [OPTIONAL] Create a new docker image based on this sample [repo](https://github.com/wbuchwalter/tf-app-container-sample) or any of your exiting repo's

    - `git clone <TODO : New Repo>`

    - `docker build -f Dockerfile.gpu -t jomit/tf-server-gpu .`

    - `docker login`

    - `docker push jomit/tf-server-gpu`

- Create an Azure Blob Storage Account with a container named `checkpoints`

- Update the values in `tensorflow-trainer.yaml`

    - `image`  (if using a custom image)

    - `STORAGE_ACCOUNT_NAME`
         
    - `STORAGE_ACCOUNT_KEY` 
    
- Create Job in k8s

    - `kubectl create -f tensorflow-trainer.yaml`

- Once Completed, check the logs and files in your Storage Account to verify

    - `kubectl logs -f <pod name>`    

## Running Jupyter Notebook

    - Create new service and deployment

        `kubectl create -f tensorflow-jupyter.yaml`

        `kubectl describe pod <pod name>`  (It should show `Successfully assigned <pod> to <agent>` under Events table)

    - Get External IP with port 8888

        `kubectl expose pod <pod name> --type=LoadBalancer --name=jupyter-service` 

        `kubectl get svc tensorflow-jupyter -o=jsonpath={.status.loadBalancer.ingress[0].ip}`

    - Get the Jupyter URL from logs

        `kubectl logs <pod name>`  (It show show a similar url : `http://localhost:8888/?token=dc2b2b0e0df49324c946bd3f2998c71239a5540559ef1023`)

    - Browse the Jupyter URL using the token and external IP

        `http://<External IP>:8888/?token=dc2b2b0e0df49324c946bd3f2998c71239a5540559ef1023`

# Helpers

- SSH into an Agent Node
    - First ssh into one of the master node 

        `ssh -i azureuser_rsa azureuser@<Master Node Public IP>`

    - Copy the `azureuser_rsa` private key on the master node

    - Change permissions `sudo chmod 600 azureuser_rsa`

    - `ssh -i azureuser_rsa azureuser@<Agent Private IP>`

- Links
    - https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/deploy.md
    - https://github.com/Azure/acs-engine/blob/master/docs/kubernetes/gpu.md
    - https://github.com/Azure/acs-engine/pull/989  


    
