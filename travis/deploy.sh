#!/usr/bin/env bash
gcloud version || true
#if [ ! -d "$HOME/google-cloud-sdk/bin" ]; then rm -rf $HOME/google-cloud-sdk; export CLOUDSDK_CORE_DISABLE_PROMPTS=1; curl https://sdk.cloud.google.com | bash; fi

curl https://sdk.cloud.google.com | bash -s -- --disable-prompts > /dev/null
export PATH=${HOME}/google-cloud-sdk/bin:${PATH}

echo ${SA_KEY} | base64 --decode -i > ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json

gcloud config set project ${PROJECT_ID}
docker build -t springapp-test:latest .
docker tag springapp-test:latest europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest
docker push europe-west2-docker.pkg.dev/${PROJECT_ID}/travis-test/springapp-test:latest