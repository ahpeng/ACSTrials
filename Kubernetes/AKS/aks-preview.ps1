# Update Azure CLI - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

# Install chocolatey - https://chocolatey.org/install#install-with-cmdexe

# Install kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-with-chocolatey-on-windows
# choco install kubernetes-cli

az provider register -n Microsoft.ContainerService

az provider show -n Microsoft.ContainerService

az group create --name ktrials --location westus2

az aks create --resource-group ktrials --name jomitk8s --agent-count 2 --generate-ssh-keys



az aks install-cli

az aks get-credentials --resource-group=ktrials --name=jomitk8s  ## Issue : https://github.com/Azure/azure-cli/issues/4746

az aks get-credentials -g ktrials -n jomitk8s -f - > config  ## workaround for above issue, copy the config file to .kube\config

kubectl get nodes

kubectl create -f azure-vote.yml

kubectl get service azure-vote-front --watch

# Browse the external-ip


### Browse the Dashboard

az aks browse -g ktrials -n jomitk8s

kubectl get all --namespace kube-system ## get the pod name using this command

kubectl port-forward kubernetes-dashboard-3427906134-f7kzq 9090 --namespace kube-system

# Browse the dashboard at : http://localhost:9090/



az group delete --name ktrials --yes --no-wait



