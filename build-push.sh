#Define image prefix from berkeley email
IMAGE_PREFIX=$(az account list --all | jq '.[].user.name' | grep -i berkeley.edu | awk -F@ '{print $1}' | tr -d '"' | tr -d "." | tr '[:upper:]' '[:lower:]' | tr '_' '-' | uniq)

#Define image name and domain name
IMAGE_NAME=project
ACR_DOMAIN=w255mids.azurecr.io

#Define tag from most recent git hash
TAG=$(git rev-parse --short HEAD)

#Replace TAG in yaml file with TAG env variable
sed "s/\[TAG\]/${TAG}/g" mlapi/.k8s/overlays/prod/patch-deployment-project-copy.yaml > mlapi/.k8s/overlays/prod/patch-deployment-project.yaml

#Define fully qualified domain name for image
IMAGE_FQDN="${ACR_DOMAIN}/${IMAGE_PREFIX}/${IMAGE_NAME}:${TAG}"

#Login to azure container repository
az acr login --name w255mids

#Tag and push image to ACR
docker tag ${IMAGE_NAME} ${IMAGE_FQDN}
docker push ${IMAGE_FQDN}

