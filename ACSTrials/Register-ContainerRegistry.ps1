Login-AzureRmAccount

Select-AzureRmSubscription -SubscriptionName "Jomit's Internal Subscription"

Register-AzureRmProviderFeature -FeatureName "PrivatePreview" -ProviderNamespace "Microsoft.ContainerRegistry" 


## Setup SSH tunnel : https://azure.microsoft.com/en-us/documentation/articles/container-service-mesos-marathon-rest/
## =================================================================================

curl http://localhost/mesos/master/slaves
curl localhost/marathon/v2/apps
#curl -X POST http://localhost/marathon/v2/apps -d marathon.json -H "Content-type: application/json"
#Invoke-WebRequest -Method Post -Uri http://localhost/marathon/v2/apps -ContentType application/json -InFile 'c:\MyApps\ACSTrials\ACSTrials\marathon.json'


## Create Azure Container Registry : https://github.com/SteveLasker/acrdocs
## =================================================================================

jackregistry

jackregistry-exp.azurecr.io

# U => jackregistry
# P => Z4S+CNB+==/HgyYLF+4nf3H66PZ18HXr

## Registry access configuration in mesosphere: https://mesosphere.github.io/marathon/docs/native-docker-private-registry.html 
## ==================================================================================

docker login jackregistry-exp.azurecr.io -u jackregistry -p Z4S+CNB+==/HgyYLF+4nf3H66PZ18HXr

docker pull nginx

docker run -it --rm -p 8080:80 nginx

docker tag nginx jackregistry-exp.azurecr.io/samples/nginx

docker push jackregistry-exp.azurecr.io/samples/nginx

docker pull jackregistry-exp.azurecr.io/samples/nginx

docker run -it --rm -p 8080:80 jackregistry-exp.azurecr.io/samples/nginx

## Copy the .docker/config.json in .gz format to some location

## Upload the nginx-private.json marathon file..


