#!/bin/bash

UNTAGGED_IMAGES=$(aws ecr list-images --repository-name $(./cf-stack-output.sh samplewebworkload-repo-dev DockerRepo) --filter "tagStatus=UNTAGGED" --query 'imageIds[*]' --output json)
aws ecr batch-delete-image --repository-name $(./cf-stack-output.sh samplewebworkload-repo-dev DockerRepo) --image-ids "$UNTAGGED_IMAGES"
aws ecr batch-delete-image --repository-name $(./cf-stack-output.sh samplewebworkload-repo-dev DockerRepo) --image-ids imageTag=latest

aws cloudformation delete-stack --stack-name samplewebworkload-fargatew-dev

aws cloudformation wait stack-delete-complete --stack-name samplewebworkload-fargatew-dev

aws cloudformation delete-stack --stack-name samplewebworkload-lb-dev
aws cloudformation delete-stack --stack-name samplewebworkload-db-dev
aws cloudformation delete-stack --stack-name samplewebworkload-repo-dev

aws cloudformation wait stack-delete-complete --stack-name samplewebworkload-lb-dev
aws cloudformation wait stack-delete-complete --stack-name samplewebworkload-db-dev

aws cloudformation delete-stack --stack-name samplewebworkload-net-dev

aws cloudformation wait stack-delete-complete --stack-name samplewebworkload-repo-dev
aws cloudformation wait stack-delete-complete --stack-name samplewebworkload-net-dev
