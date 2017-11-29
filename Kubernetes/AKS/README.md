# Setup Kubernetes on Azure

`az group create -n "myResourceGroupName" -l "westus"`


# Create Service Principle in AAD

`az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/mySubscriptionID/resourceGroups/myResourceGroupName"`

# Connect to kubernetes on Azure

`az acs kubernetes get-credentials --resource-group=myResourceGroup --name=myK8sCluster`