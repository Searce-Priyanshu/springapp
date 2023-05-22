#!/usr/bin/env bash

gcloud --quiet components install kubectl


echo ${SA_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account ${SA_NAME} --key-file ${HOME}/gcloud-service-key.json


gcloud config set project ${PROJECT_ID}
gcloud container clusters get-credentials ${CLUSTER_NAME} --zone asia-south1-a --project ${PROJECT_ID}


#1
echo Y | gcloud auth configure-docker europe-west2-docker.pkg.dev

#2
# VERSION=2.1.5
# OS=linux
# ARCH=amd64

# curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" \
# | tar xz docker-credential-gcr \
# && chmod +x docker-credential-gcr && sudo mv docker-credential-gcr /usr/bin/

# #3
# docker-credential-gcr configure-docker


docker build -t springapp-test:latest .
docker tag springapp-test:latest europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest
docker push europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest




#deploy to cloud run
# echo Y | gcloud run services set-iam-policy travis-spring-app policy.yaml

# gcloud run services replace deployment.yaml --region us-central1
# gcloud run deploy travis-spring-app --image=europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest --region=us-central1 --allow-unauthenticated


#deploy to kubernetes cluster
kubectl apply -f ./deployment.yaml

# #get status of deployement
kubectl get deployments

kubectl get pods

# kubectl get services


#FOR CONTAINER REGISTERY
#sudo docker tag springapp-test:latest us.gcr.io/${PROJECT_ID}/app-engine-tmp/app/my-first-service/ttl-18h/springapp-test:latest
#sudo docker push us.gcr.io/${PROJECT_ID}/app-engine-tmp/app/my-first-service/ttl-18h/springapp-test:latest



#add docker to group
# sudo groupadd docker
# sudo useradd travis
# sudo usermod -a -G docker travis

#sudo chown -R travis:docker /home/travis/.docker
#sudo chmod 777 "/home/travis/.docker"
